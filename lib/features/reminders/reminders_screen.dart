import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../core/i18n/arb/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/reminder.dart';
import '../shared/skeletons.dart';
import '../shared/widgets.dart';
import 'reminders_controller.dart';

/// The operator's own open reminders in three urgency sections. Tap a
/// client-linked reminder to jump into the conversation; the trailing menu
/// (house pattern — bottom sheet, mirrors the inbox) completes or snoozes.
class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(remindersControllerProvider);
    final controller = ref.read(remindersControllerProvider.notifier);

    if (state.loading && state.items.isEmpty) {
      return const SkeletonList();
    }
    if (state.error != null && state.items.isEmpty) {
      return ErrorRetry(onRetry: controller.refresh);
    }

    final sections = <(String, List<Reminder>, Color?)>[
      (l10n.remindersOverdue, state.overdue, AppColors.ember),
      (l10n.remindersToday, state.dueToday, null),
      (l10n.remindersUpcoming, state.upcoming, null),
    ];
    final nonEmpty = sections.where((s) => s.$2.isNotEmpty).toList();

    if (nonEmpty.isEmpty) {
      return RefreshIndicator(
        onRefresh: controller.refresh,
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: EmptyState(
                icon: Icons.alarm_on_rounded,
                title: l10n.remindersEmptyTitle,
                message: l10n.remindersEmptyBody,
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: ListView(
        padding: const EdgeInsets.only(bottom: Insets.xxl),
        children: [
          for (final (title, rows, accent) in nonEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Insets.lg,
                Insets.lg,
                Insets.lg,
                Insets.sm,
              ),
              child: Text(
                '$title (${rows.length})',
                style: context.text.titleSmall?.copyWith(
                  color: accent ?? context.scheme.onSurfaceVariant,
                ),
              ),
            ),
            for (final reminder in rows)
              _ReminderTile(
                reminder: reminder,
                accent: accent,
                onOpen: reminder.clientId == null
                    ? null
                    : () => context.push(_chatRoute(reminder)),
                onActions: () => _showActions(context, ref, l10n, reminder),
              ),
          ],
        ],
      ),
    );
  }

  /// Message-anchored reminders deep-link to the referenced message (the chat
  /// screen scrolls to and highlights it); others just open the conversation.
  String _chatRoute(Reminder reminder) => reminder.messageId == null
      ? '/chats/${reminder.clientId}'
      : '/chats/${reminder.clientId}?messageId=${reminder.messageId}';

  Future<void> _showActions(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    Reminder reminder,
  ) async {
    final controller = ref.read(remindersControllerProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);

    Future<void> run(Future<bool> op, String successText) async {
      final ok = await op;
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
                  run(controller.complete(reminder.id), l10n.reminderCompleted);
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
                      controller.snooze(reminder.id, until),
                      l10n.reminderSnoozed,
                    );
                  },
                ),
              if (reminder.clientId != null) ...[
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.forum_outlined),
                  title: Text(l10n.reminderOpenConversation),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    context.push(_chatRoute(reminder));
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({
    required this.reminder,
    required this.accent,
    required this.onOpen,
    required this.onActions,
  });

  final Reminder reminder;
  final Color? accent;
  final VoidCallback? onOpen;
  final VoidCallback onActions;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final due = DateFormat.MMMd(locale).add_jm().format(reminder.dueAtDate);

    return ListTile(
      onTap: onOpen ?? onActions,
      leading: Icon(
        reminder.priority == ReminderPriority.high
            ? Icons.priority_high_rounded
            : Icons.alarm_rounded,
        color: accent ?? context.scheme.onSurfaceVariant,
      ),
      title: Text(reminder.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        reminder.isOverdue ? '$due · ${l10n.reminderOverdueLabel}' : due,
        style: context.text.bodySmall?.copyWith(
          color: accent ?? context.scheme.onSurfaceVariant,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert_rounded),
        tooltip: l10n.reminderActions,
        onPressed: onActions,
      ),
    );
  }
}
