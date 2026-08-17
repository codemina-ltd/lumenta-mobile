import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format.dart';
import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/repos/suppression_repo.dart';
import '../../shared/widgets.dart';
import 'client_detail_card.dart';
import 'client_detail_providers.dart';
import 'client_detail_status.dart';

/// Campaign-targeting suppressions on the contact. Read-only on mobile: the
/// "blocked" banner and the list of active blocks; adding or releasing a
/// suppression happens on the web portal.
class ClientSuppressionCard extends ConsumerWidget {
  const ClientSuppressionCard({super.key, required this.clientId});
  final String clientId;

  void _refresh(WidgetRef ref) =>
      ref.invalidate(clientSuppressionsProvider(clientId));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(clientSuppressionsProvider(clientId));

    return ClientDetailCard(
      title: l10n.clientDetailSuppression,
      icon: Icons.block_outlined,
      child: async.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: Insets.sm),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, _) => ClientDetailCardError(onRetry: () => _refresh(ref)),
        data: (rows) {
          if (rows.isEmpty) {
            return ClientDetailEmpty(l10n.clientDetailSuppressionNone);
          }
          final blocksAll = rows.any((r) => r.scope == 'all');
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Insets.md),
                decoration: BoxDecoration(
                  color: (blocksAll ? AppColors.ember : AppColors.amber)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(Radii.sm),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.block_rounded,
                      size: 18,
                      color: blocksAll ? AppColors.ember : AppColors.amber,
                    ),
                    const SizedBox(width: Insets.sm),
                    Expanded(
                      child: Text(
                        blocksAll
                            ? l10n.clientDetailSuppressedAll
                            : l10n.clientDetailSuppressedMarketing,
                        style: context.text.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Insets.sm),
              for (final r in rows) _SuppressionRow(row: r),
            ],
          );
        },
      ),
    );
  }
}

class _SuppressionRow extends StatelessWidget {
  const _SuppressionRow({required this.row});
  final ClientSuppression row;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final created = row.createdAt == null
        ? null
        : DateTime.tryParse(row.createdAt!)?.toLocal();
    final subtitle = [
      suppressionReasonLabel(l10n, row.reason),
      if (created != null) Fmt.listTimestamp(context, created),
    ].join(' · ');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusPill(
            label: suppressionScopeLabel(l10n, row.scope),
            color: row.scope == 'all' ? AppColors.ember : AppColors.amber,
          ),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subtitle, style: context.text.bodySmall),
                if (row.notes?.trim().isNotEmpty ?? false)
                  Text(
                    row.notes!,
                    style: context.text.labelSmall?.copyWith(
                      color: context.scheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
