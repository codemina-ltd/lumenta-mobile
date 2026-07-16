import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/format.dart';
import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/message.dart';
import 'client_detail_card.dart';
import 'client_detail_providers.dart';
import 'client_detail_status.dart';

/// Snapshot of the five most recent messages, newest first (read-only). Mirrors
/// the portal's `RecentMessagesCard`; tapping opens the full conversation.
class ClientRecentMessagesCard extends ConsumerWidget {
  const ClientRecentMessagesCard({super.key, required this.clientId});
  final String clientId;

  void _openConversation(BuildContext context) {
    // We usually arrive here from the chat, so returning there is a pop; from
    // any other entry point, navigate to the conversation instead.
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/chats/$clientId');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(clientRecentMessagesProvider(clientId));

    return ClientDetailCard(
      title: l10n.clientDetailRecentMessages,
      icon: Icons.chat_bubble_outline_rounded,
      trailing: async.asData?.value.isNotEmpty == true
          ? TextButton(
              onPressed: () => _openConversation(context),
              child: Text(l10n.clientDetailViewConversation),
            )
          : null,
      child: async.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: Insets.sm),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, _) => ClientDetailCardError(
          onRetry: () => ref.invalidate(clientRecentMessagesProvider(clientId)),
        ),
        data: (messages) {
          if (messages.isEmpty) {
            return ClientDetailEmpty(l10n.clientDetailNoRecentMessages);
          }
          // The thread endpoint returns oldest→newest; show newest first.
          final recent = messages.reversed.toList();
          return Column(
            children: [
              for (final m in recent)
                InkWell(
                  onTap: () => _openConversation(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: _MessageRow(message: m),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _MessageRow extends StatelessWidget {
  const _MessageRow({required this.message});
  final Message message;

  String _preview(AppLocalizations l10n) {
    if (message.isDeleted) return l10n.messageDeleted;
    switch (message.messageType) {
      case MessageType.image:
        return l10n.previewPhoto;
      case MessageType.sticker:
        return l10n.previewSticker;
      case MessageType.audio:
        return l10n.previewAudio;
      case MessageType.video:
        return l10n.previewVideo;
      case MessageType.document:
        return message.body.isNotEmpty ? message.body : l10n.previewDocument;
      case MessageType.location:
        return l10n.previewLocation;
      case MessageType.contacts:
        return l10n.previewContact;
      default:
        return message.body.isEmpty ? '…' : message.body;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final outbound = message.isOutbound;
    final preview = _preview(l10n);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          outbound ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
          size: 16,
          color: context.scheme.onSurfaceVariant,
        ),
        const SizedBox(width: Insets.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                outbound
                    ? l10n.clientDetailFromTeam
                    : l10n.clientDetailFromClient,
                style: context.text.labelSmall?.copyWith(
                  color: context.scheme.onSurfaceVariant,
                ),
              ),
              Text(
                preview,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textDirection: Fmt.textDirectionFor(preview),
                style: context.text.bodyMedium?.copyWith(
                  fontStyle: message.isDeleted
                      ? FontStyle.italic
                      : FontStyle.normal,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: Insets.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              Fmt.listTimestamp(context, message.createdAtDate),
              style: context.text.labelSmall?.copyWith(
                color: context.scheme.onSurfaceVariant,
              ),
            ),
            if (outbound) ...[
              const SizedBox(height: 2),
              Text(
                messageStatusLabel(l10n, message.status.name),
                style: context.text.labelSmall?.copyWith(
                  color: messageStatusColor(message.status.name),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
