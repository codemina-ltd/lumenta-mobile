import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/models/inbox_thread.dart';
import '../../data/repos/tenant_repo.dart';
import '../auth/auth_controller.dart';

/// Members of the active workspace — shared by the thread tiles (assignee
/// names) and the admin assignee picker. Deliberately not autoDispose:
/// membership changes rarely, and refetching on every inbox visit would
/// work against the inbox's request-budget discipline. Switching workspaces
/// recomputes it via the `activeTenantId` watch.
final tenantMembersProvider = FutureProvider<List<TenantMemberLite>>((
  ref,
) async {
  final tenantId = ref.watch(
    authControllerProvider.select((s) => s.activeTenantId),
  );
  if (tenantId == null) return const [];
  return ref.watch(tenantRepoProvider).members(tenantId);
});

/// Saved views for the operator inbox (LUMENTA_GROWTH plan §1.3 / §14).
enum InboxView { mine, unassigned, open, snoozed, all }

@immutable
class InboxState {
  const InboxState({
    this.items = const [],
    this.view = InboxView.mine,
    this.loading = true,
    this.loadingMore = false,
    this.error,
    this.page = 0,
    this.hasMore = true,
  });

  final List<InboxThread> items;
  final InboxView view;
  final bool loading;
  final bool loadingMore;
  final Object? error;
  final int page;
  final bool hasMore;

  InboxState copyWith({
    List<InboxThread>? items,
    InboxView? view,
    bool? loading,
    bool? loadingMore,
    Object? error,
    bool clearError = false,
    int? page,
    bool? hasMore,
  }) => InboxState(
    items: items ?? this.items,
    view: view ?? this.view,
    loading: loading ?? this.loading,
    loadingMore: loadingMore ?? this.loadingMore,
    error: clearError ? null : (error ?? this.error),
    page: page ?? this.page,
    hasMore: hasMore ?? this.hasMore,
  );
}

class InboxController extends Notifier<InboxState> {
  @override
  InboxState build() {
    // Deferred: build() must return the initial state before `state` is used.
    Future.microtask(refresh);
    return const InboxState();
  }

  // ── Mutations ────────────────────────────────────────────────────────────
  // Every thread action returns the updated thread from the server, so we
  // fold it into the in-memory list instead of refetching `/inbox/threads`
  // (mirrors the portal's RTK Query cache-write pattern — refetch-per-action
  // is what drove the API rate limit). A thread that stops matching the
  // active view is dropped; one that newly matches arrives with the next
  // pull-to-refresh.

  Future<void> assignToMe(String id) async =>
      _fold(await ref.read(inboxRepoProvider).assignToMe(id));

  /// Assign to a member, or pass `null` to unassign.
  Future<void> assignTo(String id, String? userId) async =>
      _fold(await ref.read(inboxRepoProvider).assign(id, userId));

  Future<void> setStatus(
    String id,
    String status, {
    String? snoozedUntil,
  }) async => _fold(
    await ref
        .read(inboxRepoProvider)
        .changeStatus(id, status, snoozedUntil: snoozedUntil),
  );

  Future<void> setPriority(String id, String priority) async =>
      _fold(await ref.read(inboxRepoProvider).changePriority(id, priority));

  Future<void> applyLabel(String id, String labelId) async =>
      _fold(await ref.read(inboxRepoProvider).applyLabel(id, labelId));

  Future<void> removeLabel(String id, String labelId) async =>
      _fold(await ref.read(inboxRepoProvider).removeLabel(id, labelId));

  /// Optimistic badge clear when the operator opens a thread. A server
  /// failure is deliberately swallowed — the badge reappears on the next
  /// refresh, and blocking navigation over it would be worse.
  Future<void> markReadOnOpen(InboxThread thread) async {
    if (thread.unreadCount == 0) return;
    _fold(thread.copyWith(unreadCount: 0));
    try {
      await ref.read(inboxRepoProvider).markRead(thread.id);
    } catch (_) {}
  }

  bool _matchesView(InboxThread t) => switch (state.view) {
    InboxView.mine =>
      t.assignedUserId == ref.read(authControllerProvider).user?.id,
    InboxView.unassigned => t.assignedUserId == null,
    InboxView.open => t.status == 'open',
    InboxView.snoozed => t.status == 'snoozed',
    InboxView.all => true,
  };

  void _fold(InboxThread updated) {
    final idx = state.items.indexWhere((t) => t.id == updated.id);
    if (idx == -1) return;
    final items = [...state.items];
    if (_matchesView(updated)) {
      items[idx] = updated;
    } else {
      items.removeAt(idx);
    }
    state = state.copyWith(items: items);
  }

  void setView(InboxView view) {
    if (view == state.view) return;
    state = state.copyWith(view: view, items: const [], page: 0);
    refresh();
  }

  Future<void> refresh() async {
    state = state.copyWith(loading: true, clearError: true);
    await _load(1, replace: true);
  }

  Future<void> loadMore() async {
    if (state.loadingMore || !state.hasMore || state.loading) return;
    state = state.copyWith(loadingMore: true);
    await _load(state.page + 1, replace: false);
  }

  Future<void> _load(int page, {required bool replace}) async {
    try {
      final repo = ref.read(inboxRepoProvider);
      final myId = ref.read(authControllerProvider).user?.id;
      final result = await repo.threads(
        page: page,
        status: switch (state.view) {
          InboxView.open => 'open',
          InboxView.snoozed => 'snoozed',
          _ => null,
        },
        assignedUserId: state.view == InboxView.mine ? myId : null,
        unassigned: state.view == InboxView.unassigned ? true : null,
      );
      final items = replace ? result.data : [...state.items, ...result.data];
      state = state.copyWith(
        items: items,
        loading: false,
        loadingMore: false,
        page: result.page,
        hasMore: result.hasMore,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(loading: false, loadingMore: false, error: e);
    }
  }
}

final inboxControllerProvider = NotifierProvider<InboxController, InboxState>(
  InboxController.new,
);
