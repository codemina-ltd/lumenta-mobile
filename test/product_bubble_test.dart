import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/i18n/arb/app_localizations.dart';
import 'package:mobile/data/models/message.dart';
import 'package:mobile/data/repos/commerce_repo.dart';
import 'package:mobile/features/chats/chat_providers.dart';
import 'package:mobile/features/chats/widgets/product_bubble.dart';

Message _message({
  String body = 'Product: SKU-001',
  Map<String, dynamic>? interactiveMetadata,
}) => Message(
  id: 'm1',
  direction: MessageDirection.outbound,
  body: body,
  messageType: MessageType.interactive,
  interactiveMetadata:
      interactiveMetadata ??
      const {
        'type': 'product',
        'catalogId': 'cat1',
        'productRetailerId': 'SKU-001',
      },
  createdAt: '2026-07-22T06:39:00Z',
);

Widget _host(Message message, {List<CommerceProduct>? products}) =>
    ProviderScope(
      overrides: [
        if (products != null)
          chatProductsProvider.overrideWith((ref, catalogId) async => products),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ProductMessageContent(message: message, textColor: Colors.black),
        ),
      ),
    );

void main() {
  testWidgets('renders the resolved product name, price, body and CTA', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        _message(),
        products: const [
          CommerceProduct(
            id: 'p1',
            retailerId: 'SKU-001',
            name: 'Product 1',
            priceMinor: 130000,
            currency: 'EGP',
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Product 1'), findsOneWidget);
    expect(find.text('EGP 1,300.00'), findsOneWidget);
    expect(find.text('Product: SKU-001'), findsOneWidget);
    expect(find.text('View'), findsOneWidget);
  });

  testWidgets('falls back to plain body when the product cannot be resolved', (
    tester,
  ) async {
    await tester.pumpWidget(_host(_message(), products: const []));
    await tester.pumpAndSettle();

    expect(find.text('Product: SKU-001'), findsOneWidget);
    expect(find.text('View'), findsOneWidget);
    // No product name/price block when nothing matched the retailer id.
    expect(find.textContaining('EGP'), findsNothing);
  });

  testWidgets('a custom flowCta overrides the default "View" label', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        _message(
          interactiveMetadata: const {
            'type': 'product',
            'catalogId': 'cat1',
            'productRetailerId': 'SKU-001',
            'flowCta': 'Shop now',
          },
        ),
        products: const [],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Shop now'), findsOneWidget);
    expect(find.text('View'), findsNothing);
  });
}
