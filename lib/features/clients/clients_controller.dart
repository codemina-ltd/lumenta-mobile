import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/models/client.dart';
import '../auth/auth_controller.dart';

@immutable
class ClientsState {
  const ClientsState({
    this.items = const [],
    this.loading = true,
    this.loadingMore = false,
    this.error,
    this.page = 0,
    this.hasMore = true,
    this.search = '',
  });

  final List<Client> items;
  final bool loading;
  final bool loadingMore;
  final Object? error;
  final int page;
  final bool hasMore;
  final String search;

  ClientsState copyWith({
    List<Client>? items,
    bool? loading,
    bool? loadingMore,
    Object? error,
    bool clearError = false,
    int? page,
    bool? hasMore,
    String? search,
  }) => ClientsState(
    items: items ?? this.items,
    loading: loading ?? this.loading,
    loadingMore: loadingMore ?? this.loadingMore,
    error: clearError ? null : (error ?? this.error),
    page: page ?? this.page,
    hasMore: hasMore ?? this.hasMore,
    search: search ?? this.search,
  );
}

class ClientsController extends StateNotifier<ClientsState> {
  ClientsController(this._ref) : super(const ClientsState()) {
    refresh();
  }

  final Ref _ref;

  Future<void> refresh() async {
    state = state.copyWith(loading: true, clearError: true);
    await _loadPage(1, replace: true);
  }

  void setSearch(String value) {
    if (value == state.search) return;
    state = state.copyWith(search: value, loading: true, clearError: true);
    _loadPage(1, replace: true);
  }

  Future<void> loadMore() async {
    if (state.loadingMore || !state.hasMore || state.loading) return;
    state = state.copyWith(loadingMore: true);
    await _loadPage(state.page + 1, replace: false);
  }

  Future<void> _loadPage(int page, {required bool replace}) async {
    try {
      final result = await _ref
          .read(clientsRepoProvider)
          .list(search: state.search, page: page);
      final items = replace
          ? result.data
          : [...state.items, ...result.data];
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

/// Re-created whenever the active tenant changes, so the list re-scopes.
final clientsControllerProvider =
    StateNotifierProvider.autoDispose<ClientsController, ClientsState>((ref) {
  ref.watch(authControllerProvider.select((s) => s.activeTenantId));
  return ClientsController(ref);
});
