import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/models/inbox_thread.dart';
import '../auth/auth_controller.dart';

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
