import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format.dart';
import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/repos/campaigns_repo.dart';
import '../../shared/widgets.dart';
import 'client_detail_card.dart';
import 'client_detail_providers.dart';
import 'client_detail_status.dart';

/// Campaigns that targeted this contact, each with the contact's own delivery
/// outcome. Mirrors the portal's `ClientCampaignsCard` (read-only on mobile).
class ClientCampaignsCard extends ConsumerWidget {
  const ClientCampaignsCard({super.key, required this.clientId});
  final String clientId;

  IconData _typeIcon(String type) => switch (type) {
    'template' => Icons.description_outlined,
    'flow' => Icons.account_tree_outlined,
    _ => Icons.campaign_outlined,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(clientCampaignsProvider(clientId));

    return ClientDetailCard(
      title: l10n.clientDetailCampaigns,
      icon: Icons.campaign_outlined,
      count: async.asData?.value.length,
      child: async.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: Insets.sm),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, _) => ClientDetailCardError(
          onRetry: () => ref.invalidate(clientCampaignsProvider(clientId)),
        ),
        data: (campaigns) {
          if (campaigns.isEmpty) {
            return ClientDetailEmpty(l10n.clientDetailNoCampaigns);
          }
          return Column(
            children: [
              for (final c in campaigns)
                _CampaignRow(campaign: c, icon: _typeIcon(c.type)),
            ],
          );
        },
      ),
    );
  }
}

class _CampaignRow extends StatelessWidget {
  const _CampaignRow({required this.campaign, required this.icon});
  final ClientCampaign campaign;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = (campaign.title?.trim().isNotEmpty ?? false)
        ? campaign.title!
        : l10n.clientDetailUntitledCampaign;
    final sent = campaign.sentAt == null
        ? null
        : DateTime.tryParse(campaign.sentAt!)?.toLocal();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: context.scheme.onSurfaceVariant),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.bodyMedium,
                ),
                if (sent != null)
                  Text(
                    Fmt.listTimestamp(context, sent),
                    style: context.text.labelSmall?.copyWith(
                      color: context.scheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: Insets.sm),
          if (campaign.messageStatus.isNotEmpty)
            StatusPill(
              label: messageStatusLabel(l10n, campaign.messageStatus),
              color: messageStatusColor(campaign.messageStatus),
            ),
        ],
      ),
    );
  }
}
