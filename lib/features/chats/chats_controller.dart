import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/models/conversation.dart';
import '../../data/storage/last_read_store.dart';
import '../auth/auth_controller.dart';
import 'chat_list_logic.dart';

@immutable
class ChatsState {
  const ChatsState({
    this.items = const [],
    this.loading = true,
    this.loadingMore = false,
    this.error,
    this.endpointMissing = false,
    this.page = 0,
    this.hasMore = true,
    this.unreadConversations,
  });

  final List<Conversation> items;
  final bool loading;
  final bool loadingMore;
  final Object? error;

  /// True when the deferred `/messages/conversations` endpoint isn't deployed
  /// yet (404). Lets the UI explain rather than show a generic error.
  final bool endpointMissing;
  final int page;
  final bool hasMore;

  /// Server-wide count of chats with unread inbound for this member (drives
  /// the "Unread N" chip). Null on servers predating the field.
  final int? unreadConversations;

  ChatsState copyWith({
    List<Conversation>? items,
    bool? loading,
    bool? loadingMore,
    Object? error,
    bool clearError = false,
    bool? endpointMissing,
    int? page,
    bool? hasMore,
    int? unreadConversations,
    bool clearUnreadConversations = false,
  }) => ChatsState(
    items: items ?? this.items,
    loading: loading ?? this.loading,
    loadingMore: loadingMore ?? this.loadingMore,
    error: clearError ? null : (error ?? this.error),
    endpointMissing: endpointMissing ?? this.endpointMissing,
    page: page ?? this.page,
    hasMore: hasMore ?? this.hasMore,
    unreadConversations: clearUnreadConversations
        ? null
        : (unreadConversations ?? this.unreadConversations),
  );
}

/// One list per [ChatFilter] (All / Unread): the Unread view is a server
/// filter on this member's read cursor, so it pages independently. Pin and
/// read mutations are optimistic on the instance that performed them and
/// invalidate the sibling so it refetches when next shown.
class ChatsController extends Notifier<ChatsState> {
  ChatsController(this.filter);

  final ChatFilter filter;

  @override
  ChatsState build() {
    // Re-created whenever the active tenant changes, so the list re-scopes.
    ref.watch(authControllerProvider.select((s) => s.activeTenantId));
    // Deferred: build() must return the initial state before `state` is used.
    Future.microtask(refresh);
    return const ChatsState();
  }

  ChatFilter get _sibling =>
      filter == ChatFilter.all ? ChatFilter.unread : ChatFilter.all;

  Future<void> refresh() async {
    state = state.copyWith(
      loading: true,
      clearError: true,
      endpointMissing: false,
    );
    await _loadPage(1, replace: true);
  }

  Future<void> loadMore() async {
    if (state.loadingMore || !state.hasMore || state.loading) return;
    state = state.copyWith(loadingMore: true);
    await _loadPage(state.page + 1, replace: false);
  }

  /// Pin / unpin [clientId] for this member (server-side, every device).
  /// Optimistic; returns false and restores the row when the server rejects.
  Future<bool> togglePin(String clientId) async {
    final idx = state.items.indexWhere((c) => c.clientId == clientId);
    if (idx < 0) return false;
    final before = state.items[idx];
    final pinning = !before.isPinned;
    _replace(
      before.copyWith(
        pinnedAt: pinning ? DateTime.now().toUtc().toIso8601String() : null,
      ),
    );
    try {
      final repo = ref.read(messagesRepoProvider);
      if (pinning) {
        final serverAt = await repo.pinConversation(clientId);
        if (serverAt != null) {
          _replace(before.copyWith(pinnedAt: serverAt));
        }
      } else {
        await repo.unpinConversation(clientId);
      }
      ref.invalidate(chatsControllerProvider(_sibling));
      return true;
    } catch (_) {
      _replace(before);
      return false;
    }
  }

  /// Zero the unread count for [clientIds] here and on the server. Also
  /// advances the on-device cursor so older servers (no `unreadCount`) and
  /// the thread screen agree. Server failures are swallowed: the local state
  /// already reflects what the member saw.
  Future<void> markRead(Iterable<String> clientIds) async {
    final ids = clientIds.toSet();
    if (ids.isEmpty) return;
    final now = DateTime.now();
    var cleared = 0;
    final items = [
      for (final c in state.items)
        if (ids.contains(c.clientId))
          () {
            if ((c.unreadCount ?? 0) > 0) cleared++;
            return c.copyWith(unreadCount: 0);
          }()
        else
          c,
    ];
    final unreadTotal = state.unreadConversations;
    state = state.copyWith(
      items: items,
      unreadConversations: unreadTotal == null
          ? null
          : (unreadTotal - cleared).clamp(0, 1 << 30),
    );
    await ref.read(lastReadStoreProvider.notifier).markAllRead({
      for (final c in state.items)
        if (ids.contains(c.clientId)) c.clientId: c.lastMessageAtDate ?? now,
    });
    try {
      await ref
          .read(messagesRepoProvider)
          .markConversationsRead(ids.toList(growable: false));
      ref.invalidate(chatsControllerProvider(_sibling));
    } catch (_) {
      // Keep the optimistic state; the next refresh reconciles.
    }
  }

  /// "Mark all as read" from the chats menu: every loaded unread chat.
  Future<void> markAllRead(LastReadState lastRead) => markRead([
    for (final c in state.items)
      if (conversationIsUnread(c, lastRead)) c.clientId,
  ]);

  void _replace(Conversation conv) {
    state = state.copyWith(
      items: [
        for (final c in state.items)
          if (c.clientId == conv.clientId) conv else c,
      ],
    );
  }

  Future<void> _loadPage(int page, {required bool replace}) async {
    try {
      final result = await ref
          .read(messagesRepoProvider)
          .conversations(page: page, unreadOnly: filter == ChatFilter.unread);
      final items = replace ? result.data : [...state.items, ...result.data];
      final unread = result.meta['unreadConversations'];
      state = state.copyWith(
        items: items,
        loading: false,
        loadingMore: false,
        page: result.page,
        hasMore: result.hasMore,
        clearError: true,
        unreadConversations: unread is num ? unread.toInt() : null,
        clearUnreadConversations: unread is! num,
      );
    } on DioException catch (e) {
      final missing = e.response?.statusCode == 404;
      state = state.copyWith(
        loading: false,
        loadingMore: false,
        error: e,
        endpointMissing: missing,
      );
    } catch (e) {
      state = state.copyWith(loading: false, loadingMore: false, error: e);
    }
  }
}

final chatsControllerProvider = NotifierProvider.autoDispose
    .family<ChatsController, ChatsState, ChatFilter>(ChatsController.new);

/// Refresh every chats list that is currently alive (All and/or Unread),
/// e.g. after a send bumps a conversation to the top. Lists that aren't
/// mounted are left alone — they refetch on first watch anyway.
void refreshChatsLists(Ref ref) {
  for (final f in ChatFilter.values) {
    final provider = chatsControllerProvider(f);
    if (ref.exists(provider)) ref.read(provider.notifier).refresh();
  }
}

/// [refreshChatsLists] for widget code (a [WidgetRef] is not a [Ref]).
void refreshChatsListsFromWidget(WidgetRef ref) {
  for (final f in ChatFilter.values) {
    final provider = chatsControllerProvider(f);
    if (ref.exists(provider)) ref.read(provider.notifier).refresh();
  }
}
