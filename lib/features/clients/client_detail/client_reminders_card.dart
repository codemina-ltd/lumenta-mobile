import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/reminder.dart';
import '../../reminders/reminders_controller.dart';
import 'client_detail_card.dart';
import 'client_detail_providers.dart';

/// The contact's open reminders — tenant-wide (any assignee), unlike the
/// mine-only Reminders tab. Mirrors the portal's client reminders card:
/// due time, overdue flag, priority and notes, with the house bottom-sheet
/// actions (complete / snooze).
class ClientRemindersCard extends ConsumerWidget {
  const ClientRemindersCard({super.key, required this.clientId});
  final String clientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final remindersAsync = ref.watch(clientRemindersProvider(clientId));
    final reminders = remindersAsync.asData?.value;

    return ClientDetailCard(
      title: l10n.clientDetailReminders,
      icon: Icons.alarm_rounded,
      count: (reminders?.isNotEmpty ?? false) ? reminders!.length : null,
      child: remindersAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: Insets.sm),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, _) => ClientDetailCardError(
          onRetry: () => ref.invalidate(clientRemindersProvider(clientId)),
        ),
        data: (rows) => rows.isEmpty
            ? ClientDetailEmpty(l10n.clientDetailNoReminders)
            : Column(
                children: [
                  for (final reminder in rows)
                    _ReminderRow(
                      reminder: reminder,
                      onActions: () => _showActions(context, ref, reminder),
                    ),
                ],
              ),
      ),
    );
  }

  Future<void> _showActions(
    BuildContext context,
    WidgetRef ref,
    Reminder reminder,
  ) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);

    Future<void> run(Future<void> Function() op, String successText) async {
      var ok = true;
      try {
        await op();
      } catch (_) {
        ok = false;
      }
      if (ok) {
        ref.invalidate(clientRemindersProvider(clientId));
        // Keep the Reminders tab (and its badge) in sync if the completed
        // reminder was the operator's own.
        await ref.read(remindersControllerProvider.notifier).refresh();
      }
      messenger.showSnackBar(
        SnackBar(content: Text(ok ? successText : l10n.reminderActionFailed)),
      );
    }

    DateTime tomorrowNine() {
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day + 1, 9);
    }

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.check_circle_outline_rounded),
                title: Text(l10n.reminderComplete),
                onTap: () {
                  Navigator.pop(sheetContext);
                  run(
                    () => ref.read(remindersRepoProvider).complete(reminder.id),
                    l10n.reminderCompleted,
                  );
                },
              ),
              const Divider(height: 1),
              for (final (label, until) in <(String, DateTime)>[
                (
                  l10n.reminderSnooze15m,
                  DateTime.now().add(const Duration(minutes: 15)),
                ),
                (
                  l10n.reminderSnooze1h,
                  DateTime.now().add(const Duration(hours: 1)),
                ),
                (
                  l10n.reminderSnooze3h,
                  DateTime.now().add(const Duration(hours: 3)),
                ),
                (l10n.reminderSnoozeTomorrow, tomorrowNine()),
              ])
                ListTile(
                  leading: const Icon(Icons.snooze_rounded),
                  title: Text(label),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    run(
                      () => ref
                          .read(remindersRepoProvider)
                          .snooze(reminder.id, until),
                      l10n.reminderSnoozed,
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReminderRow extends StatelessWidget {
  const _ReminderRow({required this.reminder, required this.onActions});

  final Reminder reminder;
  final VoidCallback onActions;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final due = DateFormat.MMMd(locale).add_jm().format(reminder.dueAtDate);
    final accent = reminder.isOverdue ? AppColors.ember : null;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      onTap: onActions,
      leading: Icon(
        reminder.priority == ReminderPriority.high
            ? Icons.priority_high_rounded
            : Icons.alarm_rounded,
        color: accent ?? context.scheme.onSurfaceVariant,
      ),
      title: Text(
        reminder.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            reminder.isOverdue ? '$due · ${l10n.reminderOverdueLabel}' : due,
            style: context.text.bodySmall?.copyWith(
              color: accent ?? context.scheme.onSurfaceVariant,
            ),
          ),
          if (reminder.notes?.trim().isNotEmpty ?? false)
            Text(
              reminder.notes!.trim(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.text.bodySmall?.copyWith(
                color: context.scheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert_rounded),
        tooltip: l10n.reminderActions,
        onPressed: onActions,
      ),
    );
  }
}
