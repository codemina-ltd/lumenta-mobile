import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format.dart';
import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/message.dart';
import '../../../data/repos/commerce_repo.dart';
import '../chat_providers.dart';

/// Cart/order card for an inbound WhatsApp order message ("N items ·
/// estimated total · View sent cart"), at parity with what the client saw
/// when they sent it. `OrderCaptureService` parses the raw cart out of
/// `providerRawPayload` and writes a lightweight snapshot back onto
/// `interactiveMetadata` (item count + subtotal + the created order id) —
/// mirrors the portal's `OrderMessage`. The full line-item breakdown is
/// fetched on demand when the card is tapped, via the existing
/// `GET /commerce/orders/:id`.
class OrderMessageContent extends StatelessWidget {
  const OrderMessageContent({
    super.key,
    required this.message,
    required this.textColor,
  });

  final Message message;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final itemCount = message.orderItemCount;

    // Capture hasn't run yet (rare race) or found no items — keep the plain
    // placeholder body rather than a card with nothing to show.
    if (itemCount == null) {
      return Text(
        message.body.isEmpty ? '…' : message.body,
        textDirection: Fmt.textDirectionFor(message.body),
        style: TextStyle(color: textColor, fontSize: 15, height: 1.35),
      );
    }

    final subtotalMinor = message.orderSubtotalMinor;
    final currency = message.orderCurrency;
    final total = (subtotalMinor != null && currency != null)
        ? Fmt.money(subtotalMinor, currency)
        : null;
    final orderId = message.orderId;

    return GestureDetector(
      onTap: orderId != null ? () => _showDetails(context, orderId) : null,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.signalTint,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  color: AppColors.signalDeep,
                  size: 20,
                ),
              ),
              const SizedBox(width: Insets.md),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.chatOrderItems(itemCount),
                      style: TextStyle(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (total != null)
                      Text(
                        l10n.chatOrderEstimatedTotal(total),
                        style: TextStyle(
                          color: textColor.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (orderId != null) ...[
            const SizedBox(height: Insets.sm),
            Container(height: 1, color: textColor.withValues(alpha: 0.12)),
            const SizedBox(height: Insets.sm),
            Center(
              child: Text(
                l10n.chatOrderViewCart,
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showDetails(BuildContext context, String orderId) {
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.chatOrderDetailsTitle),
        content: Consumer(
          builder: (context, ref, _) {
            final async = ref.watch(chatOrderProvider(orderId));
            return async.when(
              data: (detail) => _OrderItemsTable(items: detail.items),
              loading: () => const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, _) => Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l10n.loadingError),
              ),
            );
          },
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }
}

class _OrderItemsTable extends StatelessWidget {
  const _OrderItemsTable({required this.items});
  final List<CommerceOrderItem> items;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      width: double.maxFinite,
      child: SingleChildScrollView(
        child: Table(
          border: TableBorder.all(color: AppColors.hairline),
          columnWidths: const {
            0: FlexColumnWidth(0.5),
            1: FlexColumnWidth(0.15),
            2: FlexColumnWidth(0.35),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: context.scheme.surfaceContainerHigh,
              ),
              children: [
                _HeaderCell(l10n.chatOrderProductColumn),
                _HeaderCell(l10n.chatOrderQuantityColumn),
                _HeaderCell(l10n.chatOrderPriceColumn),
              ],
            ),
            for (final item in items)
              TableRow(
                children: [
                  _Cell(
                    (item.name?.isNotEmpty ?? false)
                        ? item.name!
                        : item.productRetailerId,
                  ),
                  _Cell('${item.quantity}'),
                  _Cell(Fmt.money(item.unitPriceMinor, item.currency)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Insets.md,
        vertical: Insets.sm,
      ),
      child: Text(
        text,
        style: context.text.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Insets.md,
        vertical: Insets.sm,
      ),
      child: Text(text, style: context.text.bodyMedium),
    );
  }
}
