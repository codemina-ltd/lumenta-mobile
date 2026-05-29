import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/models/message.dart';

@immutable
class ThreadState {
  const ThreadState({
    this.messages = const [],
    this.loading = true,
    this.loadingOlder = false,
    this.error,
    this.page = 0,
    this.hasOlder = true,
  });

  /// Sorted ascending by createdAt (oldest first → newest at the bottom).
  final List<Message> messages;
  final bool loading;
  final bool loadingOlder;
  final Object? error;
  final int page;
  final bool hasOlder;

  ThreadState copyWith({
    List<Message>? messages,
    bool? loading,
    bool? loadingOlder,
    Object? error,
    bool clearError = false,
    int? page,
    bool? hasOlder,
  }) => ThreadState(
    messages: messages ?? this.messages,
    loading: loading ?? this.loading,
    loadingOlder: loadingOlder ?? this.loadingOlder,
    error: clearError ? null : (error ?? this.error),
    page: page ?? this.page,
    hasOlder: hasOlder ?? this.hasOlder,
  );
}

class ThreadController extends StateNotifier<ThreadState> {
  ThreadController(this._ref, this.clientId) : super(const ThreadState()) {
    refresh();
  }

  final Ref _ref;
  final String clientId;

  final Map<String, Message> _byId = {};

  Future<void> refresh() async {
    _byId.clear();
    state = state.copyWith(loading: true, clearError: true);
    await _loadPage(1);
  }

  Future<void> loadOlder() async {
    if (state.loadingOlder || !state.hasOlder || state.loading) return;
    state = state.copyWith(loadingOlder: true);
    await _loadPage(state.page + 1);
  }

  Future<void> _loadPage(int page) async {
    try {
      final result =
          await _ref.read(messagesRepoProvider).thread(clientId, page: page);
      for (final m in result.data) {
        _byId[m.id] = m;
      }
      final sorted = _byId.values.toList()
        ..sort((a, b) => a.createdAtDate.compareTo(b.createdAtDate));
      state = state.copyWith(
        messages: sorted,
        loading: false,
        loadingOlder: false,
        page: result.page,
        hasOlder: result.hasMore,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(loading: false, loadingOlder: false, error: e);
    }
  }

  /// Newest message timestamp, for the local last-read cursor.
  DateTime? get newestTimestamp =>
      state.messages.isEmpty ? null : state.messages.last.createdAtDate;
}

final threadControllerProvider = StateNotifierProvider.autoDispose
    .family<ThreadController, ThreadState, String>((ref, clientId) {
  return ThreadController(ref, clientId);
});
