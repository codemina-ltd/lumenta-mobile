import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/models/conversation.dart';
import '../auth/auth_controller.dart';

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

  ChatsState copyWith({
    List<Conversation>? items,
    bool? loading,
    bool? loadingMore,
    Object? error,
    bool clearError = false,
    bool? endpointMissing,
    int? page,
    bool? hasMore,
  }) => ChatsState(
    items: items ?? this.items,
    loading: loading ?? this.loading,
    loadingMore: loadingMore ?? this.loadingMore,
    error: clearError ? null : (error ?? this.error),
    endpointMissing: endpointMissing ?? this.endpointMissing,
    page: page ?? this.page,
    hasMore: hasMore ?? this.hasMore,
  );
}

class ChatsController extends StateNotifier<ChatsState> {
  ChatsController(this._ref) : super(const ChatsState()) {
    refresh();
  }

  final Ref _ref;

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

  Future<void> _loadPage(int page, {required bool replace}) async {
    try {
      final result =
          await _ref.read(messagesRepoProvider).conversations(page: page);
      final items = replace ? result.data : [...state.items, ...result.data];
      state = state.copyWith(
        items: items,
        loading: false,
        loadingMore: false,
        page: result.page,
        hasMore: result.hasMore,
        clearError: true,
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

final chatsControllerProvider =
    StateNotifierProvider.autoDispose<ChatsController, ChatsState>((ref) {
  ref.watch(authControllerProvider.select((s) => s.activeTenantId));
  return ChatsController(ref);
});
