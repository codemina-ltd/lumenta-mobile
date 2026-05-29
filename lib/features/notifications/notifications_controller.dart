import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/models/notification.dart';
import '../auth/auth_controller.dart';

@immutable
class NotificationsState {
  const NotificationsState({
    this.items = const [],
    this.loading = true,
    this.loadingMore = false,
    this.error,
    this.cursor,
    this.hasMore = true,
    this.unreadCount = 0,
  });

  final List<AppNotification> items;
  final bool loading;
  final bool loadingMore;
  final Object? error;
  final String? cursor;
  final bool hasMore;
  final int unreadCount;

  NotificationsState copyWith({
    List<AppNotification>? items,
    bool? loading,
    bool? loadingMore,
    Object? error,
    bool clearError = false,
    String? cursor,
    bool? hasMore,
    int? unreadCount,
  }) => NotificationsState(
    items: items ?? this.items,
    loading: loading ?? this.loading,
    loadingMore: loadingMore ?? this.loadingMore,
    error: clearError ? null : (error ?? this.error),
    cursor: cursor ?? this.cursor,
    hasMore: hasMore ?? this.hasMore,
    unreadCount: unreadCount ?? this.unreadCount,
  );
}

class NotificationsController extends StateNotifier<NotificationsState> {
  NotificationsController(this._ref) : super(const NotificationsState()) {
    refresh();
  }

  final Ref _ref;

  Future<void> refresh() async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      final page = await _ref.read(notificationsRepoProvider).list();
      final count = await _ref.read(notificationsRepoProvider).unreadCount();
      state = state.copyWith(
        items: page.data,
        loading: false,
        cursor: page.nextCursor,
        hasMore: page.nextCursor != null,
        unreadCount: count,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e);
    }
  }

  Future<void> loadMore() async {
    if (state.loadingMore || !state.hasMore || state.loading) return;
    state = state.copyWith(loadingMore: true);
    try {
      final page = await _ref
          .read(notificationsRepoProvider)
          .list(cursor: state.cursor);
      state = state.copyWith(
        items: [...state.items, ...page.data],
        loadingMore: false,
        cursor: page.nextCursor,
        hasMore: page.nextCursor != null,
      );
    } catch (e) {
      state = state.copyWith(loadingMore: false, error: e);
    }
  }

  Future<void> markRead(String id) async {
    final idx = state.items.indexWhere((n) => n.id == id);
    if (idx < 0 || state.items[idx].isRead) return;
    final updated = [...state.items];
    updated[idx] = updated[idx].copyWith(
      readAt: DateTime.now().toUtc().toIso8601String(),
    );
    state = state.copyWith(
      items: updated,
      unreadCount: (state.unreadCount - 1).clamp(0, 1 << 30),
    );
    try {
      await _ref.read(notificationsRepoProvider).markRead(id);
    } catch (_) {
      // Optimistic; refresh will reconcile on next pull.
    }
  }

  Future<void> markAllRead() async {
    final updated = state.items
        .map((n) => n.isRead
            ? n
            : n.copyWith(readAt: DateTime.now().toUtc().toIso8601String()))
        .toList();
    state = state.copyWith(items: updated, unreadCount: 0);
    try {
      await _ref.read(notificationsRepoProvider).markAllRead();
    } catch (_) {}
  }
}

final notificationsControllerProvider = StateNotifierProvider.autoDispose<
    NotificationsController, NotificationsState>((ref) {
  ref.watch(authControllerProvider.select((s) => s.activeTenantId));
  return NotificationsController(ref);
});
