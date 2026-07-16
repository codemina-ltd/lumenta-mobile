import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/format.dart';
import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/client.dart';
import '../../chats/chat_providers.dart';
import '../../shared/skeletons.dart';
import '../../shared/widgets.dart';
import 'client_campaigns_card.dart';
import 'client_detail_providers.dart';
import 'client_notes_card.dart';
import 'client_orders_card.dart';
import 'client_profile_card.dart';
import 'client_recent_messages_card.dart';
import 'client_segments_card.dart';
import 'client_suppression_card.dart';
import 'client_team_card.dart';

/// Full contact profile, reached by tapping the client name in the chat header.
/// Mirrors the web portal's ClientDetail: a hero with key metrics, CRM profile,
/// team ownership, internal notes, segments, campaigns, orders, recent messages
/// and suppression. Each section owns its own query so they load independently.
class ClientDetailScreen extends ConsumerWidget {
  const ClientDetailScreen({super.key, required this.clientId});
  final String clientId;

  Future<void> _copy(BuildContext context, String text, String message) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final clientAsync = ref.watch(clientProvider(clientId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.clientDetailTitle)),
      body: clientAsync.when(
        loading: () => const SkeletonList(count: 4),
        error: (_, _) => ErrorRetry(
          message: l10n.clientDetailLoadError,
          onRetry: () => ref.invalidate(clientProvider(clientId)),
        ),
        data: (client) {
          final sections = <Widget>[
            _Hero(
              client: client,
              onCopyPhone: () =>
                  _copy(context, client.phoneNumber, l10n.messageCopied),
            ),
            _MetricsGrid(clientId: clientId, client: client),
            _CtwaBanner(clientId: clientId),
            ClientProfileCard(clientId: clientId),
            ClientTeamCard(clientId: clientId),
            ClientNotesCard(clientId: clientId),
            ClientRecentMessagesCard(clientId: clientId),
            ClientOrdersCard(clientId: clientId),
            ClientCampaignsCard(clientId: clientId),
            ClientSegmentsCard(clientId: clientId),
            ClientSuppressionCard(clientId: clientId),
          ];
          return ListView.separated(
            padding: const EdgeInsets.all(Insets.lg),
            itemCount: sections.length,
            separatorBuilder: (_, _) => const SizedBox(height: Insets.lg),
            itemBuilder: (_, i) => sections[i],
          );
        },
      ),
    );
  }
}

/// Hero card — brand banner with the avatar, name and copyable phone.
class _Hero extends StatelessWidget {
  const _Hero({required this.client, required this.onCopyPhone});

  final Client client;
  final VoidCallback onCopyPhone;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(gradient: context.brand.brand),
        padding: const EdgeInsets.all(Insets.lg),
        child: Row(
          children: [
            InitialsAvatar(initials: client.initials, radius: 30),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    client.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.titleLarge?.copyWith(
                      color: AppColors.onDarkHigh,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  InkWell(
                    onTap: onCopyPhone,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '+${client.phoneNumber}',
                          style: context.text.bodyMedium?.copyWith(
                            color: AppColors.onDarkMed,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.copy_rounded,
                          size: 14,
                          color: AppColors.onDarkMed,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The four hero metrics: joined, last message, orders count and contact id.
class _MetricsGrid extends ConsumerWidget {
  const _MetricsGrid({required this.clientId, required this.client});
  final String clientId;
  final Client client;

  String _joined(BuildContext context) {
    final raw = client.createdAt;
    final parsed = raw == null ? null : DateTime.tryParse(raw)?.toLocal();
    if (parsed == null) return '—';
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMd(locale).format(parsed);
  }

  String _shortId(String id) => id.length > 14
      ? '${id.substring(0, 8)}…${id.substring(id.length - 4)}'
      : id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final messages = ref.watch(clientRecentMessagesProvider(clientId));
    final orders = ref.watch(clientOrdersProvider(clientId));

    // Recent-messages endpoint returns oldest→newest; the last item is newest.
    final newest = messages.asData?.value.isNotEmpty == true
        ? messages.asData!.value.last.createdAtDate
        : null;

    final tiles = [
      _Metric(
        icon: Icons.event_available_outlined,
        label: l10n.clientDetailJoined,
        value: _joined(context),
      ),
      _Metric(
        icon: Icons.chat_bubble_outline_rounded,
        label: l10n.clientDetailLastMessage,
        value: newest != null
            ? Fmt.listTimestamp(context, newest)
            : l10n.clientDetailNoMessages,
      ),
      _Metric(
        icon: Icons.shopping_bag_outlined,
        label: l10n.ordersTitle,
        value: '${orders.asData?.value.length ?? 0}',
      ),
      _Metric(
        icon: Icons.badge_outlined,
        label: l10n.clientDetailContactId,
        value: _shortId(client.id),
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: client.id));
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l10n.clientDetailCopiedId)));
          }
        },
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: Insets.md,
      crossAxisSpacing: Insets.md,
      childAspectRatio: 2.4,
      children: tiles,
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(Radii.sm),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Insets.md,
            vertical: Insets.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(icon, size: 14, color: context.scheme.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.labelSmall?.copyWith(
                        color: context.scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Click-to-WhatsApp acquisition banner ("Came from …"). Renders nothing when
/// the contact has no referral.
class _CtwaBanner extends ConsumerWidget {
  const _CtwaBanner({required this.clientId});
  final String clientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ctwa = ref.watch(clientCtwaProvider(clientId)).asData?.value;
    if (ctwa == null || ctwa.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Insets.md),
      decoration: BoxDecoration(
        color: AppColors.signalTint,
        borderRadius: BorderRadius.circular(Radii.sm),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.campaign_outlined,
            size: 18,
            color: AppColors.signalDeep,
          ),
          const SizedBox(width: Insets.sm),
          Expanded(
            child: Text(
              '${l10n.contactCameFrom} ${ctwa.first.label}',
              style: context.text.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
