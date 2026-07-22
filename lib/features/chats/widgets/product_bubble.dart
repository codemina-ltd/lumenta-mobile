import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format.dart';
import '../../../core/i18n/arb/app_localizations.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../data/models/message.dart';
import '../../../data/repos/commerce_repo.dart';
import '../chat_providers.dart';

/// Rich rendering of an outbound single-product send, at parity with what
/// WhatsApp actually shows the recipient: product image, name, and price
/// above the sent body text — not just the plain body the bubble fell back
/// to before (the message row itself carries no product snapshot, only
/// `catalogId`/`productRetailerId`, so the card is looked up live from the
/// catalog's product list — same idea as [TemplateMessageContent] joining
/// live template data). Falls back to the plain body while the catalog
/// loads, on fetch failure, or if the product can't be found.
class ProductMessageContent extends ConsumerWidget {
  const ProductMessageContent({
    super.key,
    required this.message,
    required this.textColor,
  });

  final Message message;
  final Color textColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final catalogId = message.productCatalogId;
    final retailerId = message.productRetailerId;

    CommerceProduct? product;
    if (catalogId != null) {
      final async = ref.watch(chatProductsProvider(catalogId));
      final matches = async.asData?.value.where(
        (p) => p.retailerId == retailerId,
      );
      product = (matches != null && matches.isNotEmpty) ? matches.first : null;
    }

    final ctaText = message.interactiveCtaText ?? l10n.chatProductView;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (product?.imageUrl?.isNotEmpty ?? false)
          ClipRRect(
            borderRadius: BorderRadius.circular(Radii.sm),
            child: CachedNetworkImage(
              imageUrl: product!.imageUrl!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 170,
              placeholder: (_, _) => Container(
                width: double.infinity,
                height: 170,
                color: Colors.black.withValues(alpha: 0.05),
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
        if (product != null) ...[
          const SizedBox(height: 6),
          Text(
            product.name,
            textDirection: Fmt.textDirectionFor(product.name),
            style: TextStyle(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            Fmt.money(product.priceMinor, product.currency),
            style: TextStyle(
              color: textColor.withValues(alpha: 0.7),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
        ],
        Text(
          message.body.isEmpty ? '…' : message.body,
          textDirection: Fmt.textDirectionFor(message.body),
          style: TextStyle(color: textColor, fontSize: 15, height: 1.35),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: textColor.withValues(alpha: 0.15)),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Text(
            ctaText,
            textAlign: TextAlign.center,
            textDirection: Fmt.textDirectionFor(ctaText),
            style: TextStyle(
              color: textColor.withValues(alpha: 0.6),
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
