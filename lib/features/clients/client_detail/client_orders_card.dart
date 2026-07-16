import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format.dart';
import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../shared/widgets.dart';
import 'client_detail_card.dart';
import 'client_detail_providers.dart';
import 'client_detail_status.dart';

/// WhatsApp-commerce orders for the contact (read-only, newest first). Mirrors
/// the portal's `ClientOrdersCard`.
class ClientOrdersCard extends ConsumerWidget {
  const ClientOrdersCard({super.key, required this.clientId});
  final String clientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(clientOrdersProvider(clientId));

    return ClientDetailCard(
      title: l10n.ordersTitle,
      icon: Icons.shopping_bag_outlined,
      count: async.asData?.value.length,
      child: async.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: Insets.sm),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, _) => ClientDetailCardError(
          onRetry: () => ref.invalidate(clientOrdersProvider(clientId)),
        ),
        data: (orders) {
          if (orders.isEmpty) return ClientDetailEmpty(l10n.ordersEmpty);
          return Column(
            children: [
              for (final o in orders)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              o.subtotalDisplay,
                              style: context.text.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (o.placedAt != null)
                              Builder(
                                builder: (context) {
                                  final placed = DateTime.tryParse(
                                    o.placedAt!,
                                  )?.toLocal();
                                  if (placed == null) {
                                    return const SizedBox.shrink();
                                  }
                                  return Text(
                                    Fmt.listTimestamp(context, placed),
                                    style: context.text.labelSmall?.copyWith(
                                      color: context.scheme.onSurfaceVariant,
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: Insets.sm),
                      StatusPill(
                        label: orderStatusLabel(l10n, o.status),
                        color: orderStatusColor(o.status),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
