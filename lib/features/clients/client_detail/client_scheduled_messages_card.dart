import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/scheduled_message.dart';
import '../../chats/widgets/scheduled_message_actions_sheet.dart';
import '../../shared/widgets.dart';
import 'client_detail_card.dart';
import 'client_detail_providers.dart';
import 'client_detail_status.dart';

/// The contact's scheduled template sends, every status, newest-first —
/// mirrors `client_reminders_card.dart`'s shape. Row tap opens the same
/// actions sheet as the inline chat-thread bubble (View always;
/// Edit/Cancel while pending; Retry/Reschedule while failed).
class ClientScheduledMessagesCard extends ConsumerWidget {
  const ClientScheduledMessagesCard({super.key, required this.clientId});
  final String clientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(clientScheduledMessagesProvider(clientId));
    final rows = async.asData?.value;

    return ClientDetailCard(
      title: l10n.clientDetailScheduledMessages,
      icon: Icons.schedule_send_rounded,
      count: (rows?.isNotEmpty ?? false) ? rows!.length : null,
      child: async.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: Insets.sm),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, _) => ClientDetailCardError(
          onRetry: () =>
              ref.invalidate(clientScheduledMessagesProvider(clientId)),
        ),
        data: (items) => items.isEmpty
            ? ClientDetailEmpty(l10n.clientDetailNoScheduledMessages)
            : Column(
                children: [
                  for (final item in items)
                    _ScheduledRow(
                      scheduledMessage: item,
                      onTap: () => showScheduledMessageActions(
                        context,
                        ref,
                        scheduledMessage: item,
                        clientId: clientId,
                        onChanged: () => ref.invalidate(
                          clientScheduledMessagesProvider(clientId),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

class _ScheduledRow extends StatelessWidget {
  const _ScheduledRow({required this.scheduledMessage, required this.onTap});

  final ScheduledMessage scheduledMessage;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final when = DateFormat.MMMd(
      locale,
    ).add_jm().format(scheduledMessage.scheduledFor.toLocal());

    return ListTile(
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      onTap: onTap,
      leading: Icon(
        Icons.schedule_send_rounded,
        color: scheduledMessageStatusColor(scheduledMessage.status),
      ),
      title: Text(
        scheduledMessage.templateName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        when,
        style: context.text.bodySmall?.copyWith(
          color: context.scheme.onSurfaceVariant,
        ),
      ),
      trailing: StatusPill(
        label: scheduledMessageStatusLabel(l10n, scheduledMessage.status),
        color: scheduledMessageStatusColor(scheduledMessage.status),
      ),
    );
  }
}
