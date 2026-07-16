import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format.dart';
import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/repos/suppression_repo.dart';
import '../../auth/auth_controller.dart';
import '../../shared/widgets.dart';
import 'client_detail_card.dart';
import 'client_detail_providers.dart';
import 'client_detail_status.dart';

/// Campaign-targeting suppressions on the contact. Mirrors the portal's
/// `SuppressionPanel`: a "blocked" banner, the list of active blocks, and — for
/// OWNER/ADMIN — release and add-suppression actions.
class ClientSuppressionCard extends ConsumerWidget {
  const ClientSuppressionCard({super.key, required this.clientId});
  final String clientId;

  void _refresh(WidgetRef ref) =>
      ref.invalidate(clientSuppressionsProvider(clientId));

  Future<void> _run(
    BuildContext context,
    WidgetRef ref,
    Future<void> Function() action,
    String successMsg,
  ) async {
    try {
      await action();
      _refresh(ref);
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(successMsg)));
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).inboxActionFailed)),
      );
    }
  }

  Future<void> _suppress(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final scope = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: Text(l10n.suppressionScopeMarketing),
              onTap: () => Navigator.pop(sheetContext, 'marketing'),
            ),
            ListTile(
              title: Text(l10n.suppressionScopeAll),
              onTap: () => Navigator.pop(sheetContext, 'all'),
            ),
          ],
        ),
      ),
    );
    if (scope == null || !context.mounted) return;
    await _run(
      context,
      ref,
      // Manual is the portal composer's default reason for an operator block.
      () => ref
          .read(suppressionRepoProvider)
          .suppress(clientId, scope: scope, reason: 'manual'),
      l10n.clientDetailSuppressed,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(clientSuppressionsProvider(clientId));
    final role = ref
        .watch(authControllerProvider)
        .activeTenant
        ?.role
        ?.toUpperCase();
    final isAdmin = role == 'OWNER' || role == 'ADMIN';

    return ClientDetailCard(
      title: l10n.clientDetailSuppression,
      icon: Icons.block_outlined,
      trailing: isAdmin && async.asData?.value.isEmpty == true
          ? TextButton(
              onPressed: () => _suppress(context, ref),
              child: Text(l10n.clientDetailSuppress),
            )
          : null,
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
              for (final r in rows)
                _SuppressionRow(
                  row: r,
                  canRelease: isAdmin,
                  onRelease: () => _run(
                    context,
                    ref,
                    () => ref
                        .read(suppressionRepoProvider)
                        .release(clientId, scope: r.scope),
                    l10n.clientDetailReleased,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _SuppressionRow extends StatelessWidget {
  const _SuppressionRow({
    required this.row,
    required this.canRelease,
    required this.onRelease,
  });
  final ClientSuppression row;
  final bool canRelease;
  final VoidCallback onRelease;

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
          if (canRelease)
            TextButton(
              onPressed: onRelease,
              child: Text(l10n.clientDetailRelease),
            ),
        ],
      ),
    );
  }
}
