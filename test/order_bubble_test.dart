import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/i18n/arb/app_localizations.dart';
import 'package:mobile/data/models/message.dart';
import 'package:mobile/data/repos/commerce_repo.dart';
import 'package:mobile/features/chats/chat_providers.dart';
import 'package:mobile/features/chats/widgets/order_bubble.dart';

Message _message({String body = '', Map<String, dynamic>? interactiveMetadata}) =>
    Message(
      id: 'm1',
      direction: MessageDirection.inbound,
      body: body,
      messageType: MessageType.order,
      interactiveMetadata: interactiveMetadata,
      createdAt: '2026-07-22T06:40:00Z',
    );

Widget _host(Message message, {CommerceOrderDetail? orderDetail}) =>
    ProviderScope(
      overrides: [
        if (orderDetail != null)
          chatOrderProvider.overrideWith((ref, orderId) async => orderDetail),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: OrderMessageContent(message: message, textColor: Colors.black),
        ),
      ),
    );

void main() {
  testWidgets('falls back to plain body before capture has run', (
    tester,
  ) async {
    await tester.pumpWidget(_host(_message(body: '[Order]')));
    await tester.pumpAndSettle();
    expect(find.text('[Order]'), findsOneWidget);
  });

  testWidgets('renders item count, estimated total and the view-cart action', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        _message(
          interactiveMetadata: const {
            'type': 'order',
            'orderId': 'o1',
            'catalogId': '3040941292778283',
            'itemCount': 1,
            'subtotalMinor': 130000,
            'currency': 'EGP',
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('1 item'), findsOneWidget);
    expect(find.text('EGP 1,300.00 (estimated total)'), findsOneWidget);
    expect(find.text('View sent cart'), findsOneWidget);
  });

  testWidgets('pluralises multi-item carts', (tester) async {
    await tester.pumpWidget(
      _host(
        _message(
          interactiveMetadata: const {
            'type': 'order',
            'orderId': 'o2',
            'itemCount': 3,
            'subtotalMinor': 390000,
            'currency': 'EGP',
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('3 items'), findsOneWidget);
  });

  testWidgets('tapping the card opens the order-details table', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        _message(
          interactiveMetadata: const {
            'type': 'order',
            'orderId': 'o1',
            'itemCount': 1,
            'subtotalMinor': 130000,
            'currency': 'EGP',
          },
        ),
        orderDetail: const CommerceOrderDetail(
          order: CommerceOrder(
            id: 'o1',
            status: 'pending',
            subtotalMinor: 130000,
            currency: 'EGP',
          ),
          items: [
            CommerceOrderItem(
              id: 'i1',
              productRetailerId: 'SKU-001',
              name: 'Product 1',
              quantity: 1,
              unitPriceMinor: 130000,
              currency: 'EGP',
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('View sent cart'));
    await tester.pumpAndSettle();

    expect(find.text('Order details'), findsOneWidget);
    expect(find.text('Product 1'), findsOneWidget);
    expect(find.text('EGP 1,300.00'), findsOneWidget);
  });
}
