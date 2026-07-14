import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/models/client_search.dart';
import '../auth/auth_controller.dart';

/// Server-enforced minimum query length for `GET /search/clients`.
const kSearchMinQueryLength = 2;

@immutable
class SearchState {
  const SearchState({
    this.query = '',
    this.results = const [],
    this.loading = false,
    this.error,
  });

  final String query;
  final List<ClientSearchResult> results;
  final bool loading;
  final Object? error;

  SearchState copyWith({
    String? query,
    List<ClientSearchResult>? results,
    bool? loading,
    Object? error,
    bool clearError = false,
  }) => SearchState(
    query: query ?? this.query,
    results: results ?? this.results,
    loading: loading ?? this.loading,
    error: clearError ? null : (error ?? this.error),
  );
}

/// Owns the global-search query/results. Debounce lives in the screen (same
/// split as the clients list); this controller guards against out-of-order
/// responses so a slow early request can never overwrite a newer one.
class SearchController extends Notifier<SearchState> {
  @override
  SearchState build() {
    // Re-created whenever the active tenant changes, so results re-scope.
    ref.watch(authControllerProvider.select((s) => s.activeTenantId));
    return const SearchState();
  }

  Future<void> setQuery(String value) async {
    final q = value.trim();
    if (q == state.query && state.error == null) return;
    if (q.length < kSearchMinQueryLength) {
      state = SearchState(query: q);
      return;
    }
    state = state.copyWith(query: q, loading: true, clearError: true);
    try {
      final results = await ref.read(searchRepoProvider).searchClients(q);
      if (state.query != q) return; // a newer query superseded this one
      state = state.copyWith(results: results, loading: false);
    } catch (e) {
      if (state.query != q) return;
      state = state.copyWith(loading: false, error: e);
    }
  }

  Future<void> retry() => setQuery(state.query);
}

final searchControllerProvider =
    NotifierProvider.autoDispose<SearchController, SearchState>(
      SearchController.new,
    );
