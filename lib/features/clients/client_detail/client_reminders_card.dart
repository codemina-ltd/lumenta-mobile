import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/reminder.dart';
import 'client_detail_card.dart';
import 'client_detail_providers.dart';

/// The contact's open reminders — tenant-wide (any assignee), unlike the
/// mine-only Reminders tab. Read-only on mobile: due time, overdue flag,
/// priority and notes; complete/snooze happen on the web portal.
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
                  for (final reminder in rows) _ReminderRow(reminder: reminder),
                ],
              ),
      ),
    );
  }
}

class _ReminderRow extends StatelessWidget {
  const _ReminderRow({required this.reminder});

  final Reminder reminder;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final due = DateFormat.MMMd(locale).add_jm().format(reminder.dueAtDate);
    final accent = reminder.isOverdue ? AppColors.ember : null;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      leading: Icon(
        reminder.priority == ReminderPriority.high
            ? Icons.priority_high_rounded
            : Icons.alarm_rounded,
        color: accent ?? context.scheme.onSurfaceVariant,
      ),
      title: Text(reminder.title, maxLines: 2, overflow: TextOverflow.ellipsis),
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
    );
  }
}
