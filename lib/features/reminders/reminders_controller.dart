import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/models/reminder.dart';
import '../auth/auth_controller.dart';

@immutable
class RemindersState {
  const RemindersState({
    this.items = const [],
    this.summary = const ReminderSummary(),
    this.loading = true,
    this.error,
  });

  final List<Reminder> items;
  final ReminderSummary summary;
  final bool loading;
  final Object? error;

  /// Badge count for the tab: what needs attention *now*.
  int get dueCount => summary.overdue + summary.dueToday;

  List<Reminder> get overdue =>
      items.where((r) => r.isOverdue).toList();

  List<Reminder> get dueToday {
    final now = DateTime.now();
    final endOfDay = DateTime(now.year, now.month, now.day + 1);
    return items
        .where((r) => !r.isOverdue && r.dueAtDate.isBefore(endOfDay))
        .toList();
  }

  List<Reminder> get upcoming {
    final now = DateTime.now();
    final endOfDay = DateTime(now.year, now.month, now.day + 1);
    return items.where((r) => !r.dueAtDate.isBefore(endOfDay)).toList();
  }

  RemindersState copyWith({
    List<Reminder>? items,
    ReminderSummary? summary,
    bool? loading,
    Object? error,
    bool clearError = false,
  }) => RemindersState(
    items: items ?? this.items,
    summary: summary ?? this.summary,
    loading: loading ?? this.loading,
    error: clearError ? null : (error ?? this.error),
  );
}

/// Owns the operator's own open reminders ("mine only" — plan §5) plus the
/// tz-aware summary that feeds the tab badge. Complete/snooze are optimistic;
/// a background refresh reconciles counts.
class RemindersController extends Notifier<RemindersState> {
  @override
  RemindersState build() {
    // Re-created whenever the active tenant changes, so the list re-scopes.
    ref.watch(authControllerProvider.select((s) => s.activeTenantId));
    // Deferred: build() must return the initial state before `state` is used.
    Future.microtask(refresh);
    return const RemindersState();
  }

  Future<void> refresh() async {
    state = state.copyWith(loading: state.items.isEmpty, clearError: true);
    try {
      final userId = ref.read(authControllerProvider).user?.id;
      final repo = ref.read(remindersRepoProvider);
      final page = await repo.list(assignedToUserId: userId);
      final summary = await repo.summary(tz: _deviceIanaTz());
      state = state.copyWith(
        items: page.data,
        summary: summary,
        loading: false,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e);
    }
  }

  Future<bool> complete(String id) async {
    final before = state;
    state = state.copyWith(
      items: state.items.where((r) => r.id != id).toList(),
    );
    try {
      await ref.read(remindersRepoProvider).complete(id);
      await refresh();
      return true;
    } catch (_) {
      state = before;
      return false;
    }
  }

  Future<bool> snooze(String id, DateTime until) async {
    final before = state;
    state = state.copyWith(
      items: [
        for (final r in state.items)
          if (r.id == id)
            r.copyWith(
              dueAt: until.toUtc().toIso8601String(),
              snoozeCount: r.snoozeCount + 1,
            )
          else
            r,
      ],
    );
    try {
      await ref.read(remindersRepoProvider).snooze(id, until);
      await refresh();
      return true;
    } catch (_) {
      state = before;
      return false;
    }
  }
}

/// The device's IANA timezone name (e.g. `Africa/Cairo`) via the Dart VM's
/// `Intl`-backed environment; falls back to null (server uses the profile tz).
String? _deviceIanaTz() {
  // `DateTime().timeZoneName` gives an abbreviation (EET), not IANA — the
  // reliable cross-platform source without another dependency:
  final tz = DateTime.now().timeZoneName;
  // Heuristic: only pass through values that look like IANA identifiers.
  return tz.contains('/') ? tz : null;
}

final remindersControllerProvider =
    NotifierProvider.autoDispose<RemindersController, RemindersState>(
      RemindersController.new,
    );
