import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/i18n/arb/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/tenant.dart';
import 'auth_controller.dart';

/// Workspace picker shown when a user belongs to >1 tenant (or none active yet).
class TenantPickerScreen extends ConsumerWidget {
  const TenantPickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tenants = ref.watch(
      authControllerProvider.select((s) => s.tenants),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tenantPickerTitle),
        actions: [
          // Escape hatch: without it a user whose every workspace is blocked
          // (or whose tenant list failed to load) has no way to sign out.
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.ember),
            tooltip: l10n.logout,
            onPressed: () =>
                ref.read(authControllerProvider.notifier).logout(),
          ),
          const SizedBox(width: Insets.sm),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          Insets.lg,
          Insets.md,
          Insets.lg,
          Insets.lg,
        ),
        itemCount: tenants.length,
        separatorBuilder: (_, _) => const SizedBox(height: Insets.md),
        itemBuilder: (context, i) {
          final TenantSummary t = tenants[i];
          // KAN-64 — a workspace with mobile login OFF is shown greyed and, on
          // tap, explains it's disabled rather than entering. Compliance-
          // inactive workspaces stay fully non-interactive (null onTap).
          final selectable = t.isActive && t.mobileLoginEnabled;
          final mobileBlocked = t.isActive && !t.mobileLoginEnabled;
          return _TenantCard(
            tenant: t,
            disabled: !selectable,
            onTap: selectable
                ? () => ref
                    .read(authControllerProvider.notifier)
                    .selectTenant(t.id)
                : mobileBlocked
                ? () => ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(content: Text(l10n.tenantMobileLoginDisabled)),
                    )
                : null,
          );
        },
      ),
    );
  }
}

class _TenantCard extends StatelessWidget {
  const _TenantCard({
    required this.tenant,
    required this.onTap,
    required this.disabled,
  });

  final TenantSummary tenant;
  final VoidCallback? onTap;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final letter = tenant.name.isNotEmpty ? tenant.name[0].toUpperCase() : '?';

    return Opacity(
      opacity: disabled ? 0.5 : 1,
      child: Material(
        color: context.scheme.surfaceContainerLow,
        borderRadius: Radii.card,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(Insets.lg),
            decoration: BoxDecoration(
              borderRadius: Radii.card,
              border: Border.all(color: context.scheme.outlineVariant),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: context.brand.accent,
                    borderRadius: BorderRadius.circular(Radii.md),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    letter,
                    style: context.text.titleLarge?.copyWith(
                      color: AppColors.deepForest,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: Insets.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tenant.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.titleMedium,
                      ),
                      if (tenant.role != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          tenant.role!,
                          style: context.text.bodySmall?.copyWith(
                            color: context.scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: context.scheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
