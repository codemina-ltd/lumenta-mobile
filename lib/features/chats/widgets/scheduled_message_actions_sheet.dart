import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/scheduled_message.dart';
import '../../../data/repos/scheduled_messages_repo.dart';
import '../../clients/client_detail/client_detail_status.dart';
import '../../shared/widgets.dart';
import '../../templates/template_fill_screen.dart';
import '../chat_providers.dart';

enum _ScheduledAction { view, edit, cancel, retry, reschedule }

/// Action sheet for one scheduled message — shared by the inline chat-thread
/// bubble ([_ScheduledMessageBubble] in `chat_detail_screen.dart`) and the
/// Client Profile "Scheduled Messages" card
/// (`client_scheduled_messages_card.dart`), so both surfaces behave
/// identically. Offers View always; Edit/Cancel while `pending`;
/// Retry/Reschedule while `failed`. [onChanged] is called after any
/// successful mutation so the caller can invalidate its list provider.
Future<void> showScheduledMessageActions(
  BuildContext context,
  WidgetRef ref, {
  required ScheduledMessage scheduledMessage,
  required String clientId,
  required VoidCallback onChanged,
}) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);

  final action = await showModalBottomSheet<_ScheduledAction>(
    context: context,
    builder: (sheetCtx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Insets.sm, 0, Insets.sm, Insets.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ActionTile(
              icon: Icons.info_outline_rounded,
              color: AppColors.signalDeep,
              label: l10n.scheduledMessageView,
              onTap: () => Navigator.pop(sheetCtx, _ScheduledAction.view),
            ),
            if (scheduledMessage.isPending) ...[
              _ActionTile(
                icon: Icons.edit_outlined,
                color: AppColors.lilac,
                label: l10n.scheduledMessageEdit,
                onTap: () => Navigator.pop(sheetCtx, _ScheduledAction.edit),
              ),
              _ActionTile(
                icon: Icons.event_busy_rounded,
                color: AppColors.ember,
                label: l10n.scheduledMessageCancelAction,
                onTap: () => Navigator.pop(sheetCtx, _ScheduledAction.cancel),
              ),
            ],
            if (scheduledMessage.isFailed) ...[
              _ActionTile(
                icon: Icons.refresh_rounded,
                color: AppColors.signal,
                label: l10n.scheduledMessageRetryAction,
                onTap: () => Navigator.pop(sheetCtx, _ScheduledAction.retry),
              ),
              _ActionTile(
                icon: Icons.schedule_rounded,
                color: AppColors.amber,
                label: l10n.scheduledMessageRescheduleAction,
                onTap: () =>
                    Navigator.pop(sheetCtx, _ScheduledAction.reschedule),
              ),
            ],
          ],
        ),
      ),
    ),
  );
  if (action == null || !context.mounted) return;

  switch (action) {
    case _ScheduledAction.view:
      await _showDetail(
        context,
        ref,
        clientId: clientId,
        id: scheduledMessage.id,
      );
    case _ScheduledAction.edit:
      await _edit(
        context,
        ref,
        messenger,
        l10n,
        scheduledMessage: scheduledMessage,
        clientId: clientId,
        onChanged: onChanged,
      );
    case _ScheduledAction.cancel:
      await _cancel(
        context,
        ref,
        messenger,
        l10n,
        scheduledMessage: scheduledMessage,
        clientId: clientId,
        onChanged: onChanged,
      );
    case _ScheduledAction.retry:
      await _retry(
        ref,
        messenger,
        l10n,
        scheduledMessage: scheduledMessage,
        clientId: clientId,
        onChanged: onChanged,
      );
    case _ScheduledAction.reschedule:
      await _reschedule(
        context,
        ref,
        messenger,
        l10n,
        scheduledMessage: scheduledMessage,
        clientId: clientId,
        onChanged: onChanged,
      );
  }
}

Future<void> _showDetail(
  BuildContext context,
  WidgetRef ref, {
  required String clientId,
  required String id,
}) async {
  final l10n = AppLocalizations.of(context);
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetCtx) => SafeArea(
      child: FutureBuilder<ScheduledMessageDetail>(
        future: ref.read(scheduledMessagesRepoProvider).get(clientId, id),
        builder: (ctx, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Padding(
              padding: EdgeInsets.all(Insets.xxxl),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (!snap.hasData) {
            return Padding(
              padding: const EdgeInsets.all(Insets.xxxl),
              child: Text(
                l10n.scheduledMessageLoadFailed,
                textAlign: TextAlign.center,
              ),
            );
          }
          return _ScheduledDetailSheet(detail: snap.data!);
        },
      ),
    ),
  );
}

/// Fetches the [Template] behind [scheduledMessage] and pushes
/// [TemplateFillScreen] in edit mode. Falls back to a snackbar when the
/// template was deleted (`templateId` null) — there's nothing to rebuild the
/// variable fields from, so editing is unavailable (reschedule still works
/// via the failed-message flow once it fails, or by cancelling and
/// re-scheduling).
Future<void> _edit(
  BuildContext context,
  WidgetRef ref,
  ScaffoldMessengerState messenger,
  AppLocalizations l10n, {
  required ScheduledMessage scheduledMessage,
  required String clientId,
  required VoidCallback onChanged,
}) async {
  final templateId = scheduledMessage.templateId;
  if (templateId == null) {
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.scheduledMessageTemplateUnavailable)),
    );
    return;
  }
  try {
    final template = await ref.read(templatesRepoProvider).byId(templateId);
    if (!context.mounted) return;
    final client = await ref.read(clientProvider(clientId).future);
    if (!context.mounted) return;
    final threadKey = (clientId: clientId, senderId: scheduledMessage.senderId);
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => TemplateFillScreen(
          template: template,
          threadKey: threadKey,
          to: client.phoneNumber,
          editing: scheduledMessage,
        ),
      ),
    );
    if (saved == true) {
      onChanged();
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.scheduledMessageUpdated)),
      );
    }
  } catch (_) {
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.scheduledMessageTemplateUnavailable)),
    );
  }
}

Future<void> _cancel(
  BuildContext context,
  WidgetRef ref,
  ScaffoldMessengerState messenger,
  AppLocalizations l10n, {
  required ScheduledMessage scheduledMessage,
  required String clientId,
  required VoidCallback onChanged,
}) async {
  final reasonCtrl = TextEditingController();
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogCtx) => AlertDialog(
      title: Text(l10n.scheduledMessageCancelTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.scheduledMessageCancelConfirm),
          const SizedBox(height: Insets.md),
          TextField(
            controller: reasonCtrl,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: l10n.scheduledMessageCancelReasonLabel,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogCtx, false),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogCtx, true),
          style: TextButton.styleFrom(foregroundColor: AppColors.ember),
          child: Text(l10n.scheduledMessageCancelAction),
        ),
      ],
    ),
  );
  if (confirmed != true) return;
  try {
    final reason = reasonCtrl.text.trim();
    await ref
        .read(scheduledMessagesRepoProvider)
        .cancel(
          clientId,
          scheduledMessage.id,
          reason: reason.isEmpty ? null : reason,
        );
    onChanged();
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.scheduledMessageCancelledSnack)),
    );
  } catch (_) {
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.scheduledMessageCancelFailed)),
    );
  }
}

Future<void> _retry(
  WidgetRef ref,
  ScaffoldMessengerState messenger,
  AppLocalizations l10n, {
  required ScheduledMessage scheduledMessage,
  required String clientId,
  required VoidCallback onChanged,
}) async {
  try {
    await ref
        .read(scheduledMessagesRepoProvider)
        .retry(clientId, scheduledMessage.id);
    onChanged();
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.scheduledMessageRetriedSnack)),
    );
  } catch (_) {
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.scheduledMessageRetryFailed)),
    );
  }
}

Future<void> _reschedule(
  BuildContext context,
  WidgetRef ref,
  ScaffoldMessengerState messenger,
  AppLocalizations l10n, {
  required ScheduledMessage scheduledMessage,
  required String clientId,
  required VoidCallback onChanged,
}) async {
  final now = DateTime.now();
  final date = await showDatePicker(
    context: context,
    initialDate: now.add(const Duration(hours: 1)),
    firstDate: now,
    lastDate: now.add(const Duration(days: 365)),
  );
  if (date == null || !context.mounted) return;
  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(now.add(const Duration(hours: 1))),
  );
  if (time == null) return;
  final when = DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
  );
  if (!when.isAfter(DateTime.now())) {
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.scheduledMessageMustBeFuture)),
    );
    return;
  }
  try {
    await ref
        .read(scheduledMessagesRepoProvider)
        .retry(clientId, scheduledMessage.id, scheduledFor: when);
    onChanged();
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.scheduledMessageRescheduledSnack)),
    );
  } catch (_) {
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.scheduledMessageRescheduleFailed)),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(Radii.md),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(label, style: context.text.titleMedium),
    );
  }
}

/// "View" sheet content — the message's current state plus its full
/// lifecycle/activity history, newest first.
class _ScheduledDetailSheet extends StatelessWidget {
  const _ScheduledDetailSheet({required this.detail});

  final ScheduledMessageDetail detail;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final m = detail.message;
    final when = DateFormat.MMMd(locale).add_jm().format(m.scheduledFor);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        Insets.lg,
        Insets.sm,
        Insets.lg,
        Insets.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(m.templateName, style: context.text.titleMedium),
              ),
              const SizedBox(width: Insets.sm),
              StatusPill(
                label: scheduledMessageStatusLabel(l10n, m.status),
                color: scheduledMessageStatusColor(m.status),
              ),
            ],
          ),
          const SizedBox(height: Insets.xs),
          Text(
            l10n.scheduledMessageFor(when),
            style: context.text.bodySmall?.copyWith(
              color: context.scheme.onSurfaceVariant,
            ),
          ),
          if ((m.renderedBody ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: Insets.md),
            Text(m.renderedBody!.trim()),
          ],
          if (m.isFailed && (m.errorMessage?.trim().isNotEmpty ?? false)) ...[
            const SizedBox(height: Insets.md),
            Text(
              '${l10n.scheduledMessageErrorLabel}: ${m.errorMessage!.trim()}',
              style: TextStyle(color: context.scheme.error),
            ),
          ],
          const SizedBox(height: Insets.xl),
          Text(
            l10n.scheduledMessageActivityTitle,
            style: context.text.titleSmall,
          ),
          const SizedBox(height: Insets.sm),
          for (final e in detail.events) _EventRow(event: e),
        ],
      ),
    );
  }
}

class _EventRow extends StatelessWidget {
  const _EventRow({required this.event});

  final ScheduledMessageEvent event;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final when = DateFormat.MMMd(locale).add_jm().format(event.createdAtDate);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            _eventIcon(event.eventType),
            size: 16,
            color: context.scheme.onSurfaceVariant,
          ),
          const SizedBox(width: Insets.sm),
          Expanded(child: Text(_eventLabel(l10n, event.eventType))),
          Text(
            when,
            style: context.text.labelSmall?.copyWith(
              color: context.scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

IconData _eventIcon(ScheduledMessageEventType type) => switch (type) {
  ScheduledMessageEventType.scheduled => Icons.event_available_rounded,
  ScheduledMessageEventType.edited => Icons.edit_rounded,
  ScheduledMessageEventType.cancelled => Icons.event_busy_rounded,
  ScheduledMessageEventType.sent => Icons.check_circle_rounded,
  ScheduledMessageEventType.failed => Icons.error_rounded,
};

String _eventLabel(
  AppLocalizations l10n,
  ScheduledMessageEventType type,
) => switch (type) {
  ScheduledMessageEventType.scheduled => l10n.scheduledMessageEventScheduled,
  ScheduledMessageEventType.edited => l10n.scheduledMessageEventEdited,
  ScheduledMessageEventType.cancelled => l10n.scheduledMessageEventCancelled,
  ScheduledMessageEventType.sent => l10n.scheduledMessageEventSent,
  ScheduledMessageEventType.failed => l10n.scheduledMessageEventFailed,
};
