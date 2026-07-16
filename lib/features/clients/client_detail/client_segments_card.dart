import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../features/shared/widgets.dart';
import 'client_detail_card.dart';
import 'client_detail_providers.dart';

/// Audience segments the contact belongs to (read-only tags). Mirrors the
/// portal's Segments card.
class ClientSegmentsCard extends ConsumerWidget {
  const ClientSegmentsCard({super.key, required this.clientId});
  final String clientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(clientSegmentsProvider(clientId));

    return ClientDetailCard(
      title: l10n.clientDetailSegments,
      icon: Icons.sell_outlined,
      count: async.asData?.value.length,
      child: async.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: Insets.sm),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, _) => ClientDetailCardError(
          onRetry: () => ref.invalidate(clientSegmentsProvider(clientId)),
        ),
        data: (segments) {
          if (segments.isEmpty) {
            return ClientDetailEmpty(l10n.clientDetailNoSegments);
          }
          return Wrap(
            spacing: Insets.sm,
            runSpacing: Insets.sm,
            children: [
              for (final s in segments)
                StatusPill(
                  label: s.name,
                  color: AppColors.lilac,
                  icon: Icons.sell_outlined,
                ),
            ],
          );
        },
      ),
    );
  }
}
