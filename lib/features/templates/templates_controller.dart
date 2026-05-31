import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/models/template.dart';
import '../auth/auth_controller.dart';

@immutable
class TemplatesState {
  const TemplatesState({
    this.items = const [],
    this.loading = true,
    this.error,
    this.search = '',
  });

  final List<Template> items;
  final bool loading;
  final Object? error;
  final String search;

  TemplatesState copyWith({
    List<Template>? items,
    bool? loading,
    Object? error,
    bool clearError = false,
    String? search,
  }) => TemplatesState(
    items: items ?? this.items,
    loading: loading ?? this.loading,
    error: clearError ? null : (error ?? this.error),
    search: search ?? this.search,
  );
}

/// Owns the approved-template list for the chat picker. Mirrors the portal,
/// which fetches a single page of `limit: 100` with no pagination; search is
/// applied server-side via the same `/templates` endpoint.
class TemplatesController extends StateNotifier<TemplatesState> {
  TemplatesController(this._ref) : super(const TemplatesState()) {
    refresh();
  }

  final Ref _ref;

  Future<void> refresh() async {
    state = state.copyWith(loading: true, clearError: true);
    await _load();
  }

  void setSearch(String value) {
    if (value == state.search) return;
    state = state.copyWith(search: value, loading: true, clearError: true);
    _load();
  }

  Future<void> _load() async {
    try {
      final result = await _ref
          .read(templatesRepoProvider)
          .approved(search: state.search);
      state = state.copyWith(
        items: result.data,
        loading: false,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e);
    }
  }
}

/// Re-created whenever the active tenant changes, so the list re-scopes.
final templatesControllerProvider =
    StateNotifierProvider.autoDispose<TemplatesController, TemplatesState>((ref) {
  ref.watch(authControllerProvider.select((s) => s.activeTenantId));
  return TemplatesController(ref);
});
