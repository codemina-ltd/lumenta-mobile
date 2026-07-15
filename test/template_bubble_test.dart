import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/i18n/arb/app_localizations.dart';
import 'package:mobile/data/models/message.dart';
import 'package:mobile/data/models/template.dart';
import 'package:mobile/features/chats/chat_providers.dart';
import 'package:mobile/features/chats/widgets/template_bubble.dart';

Message _message({String? templateId, String body = 'Hello Ebrahim'}) =>
    Message(
      id: 'm1',
      direction: MessageDirection.outbound,
      body: body,
      messageType: MessageType.template,
      providerRawPayload: templateId == null
          ? null
          : {
              'templateInfo': {'templateId': templateId},
            },
      createdAt: '2026-07-15T10:00:00Z',
    );

Widget _host(Message message, {Template? template}) => ProviderScope(
  overrides: [
    if (template != null)
      chatTemplateProvider.overrideWith((ref, id) async => template),
  ],
  child: MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: TemplateMessageContent(message: message, textColor: Colors.black),
    ),
  ),
);

// The send-template preview renders the same [TemplateContentView] the sent
// bubble does, fed a live-filled body — so a header/footer/buttons/formatting
// appear identically before sending.
Widget _previewHost(
  Template template,
  String body, {
  double sidePadding = 0,
  double topPadding = 0,
}) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(
    body: TemplateContentView(
      template: template,
      body: body,
      textColor: Colors.black,
      sidePadding: sidePadding,
      topPadding: topPadding,
    ),
  ),
);

void main() {
  testWidgets('falls back to plain body without an internal template id', (
    tester,
  ) async {
    await tester.pumpWidget(_host(_message()));
    expect(find.text('Hello Ebrahim'), findsOneWidget);
  });

  testWidgets('renders footer and collapses >3 buttons behind see-all', (
    tester,
  ) async {
    const template = Template(
      id: 't1',
      body: 'Hello {{1}}',
      footerText: 'Reply STOP to opt out',
      buttons: [
        {'type': 'QUICK_REPLY', 'text': 'Yes'},
        {'type': 'QUICK_REPLY', 'text': 'No'},
        {'type': 'URL', 'text': 'Open site', 'url': 'https://x.com'},
        {'type': 'PHONE_NUMBER', 'text': 'Call us', 'phone_number': '123'},
      ],
    );
    await tester.pumpWidget(
      _host(_message(templateId: 't1'), template: template),
    );
    await tester.pumpAndSettle();

    expect(find.text('Reply STOP to opt out'), findsOneWidget);
    // WhatsApp collapse rule: 2 shown + "See all options".
    expect(find.text('Yes'), findsOneWidget);
    expect(find.text('No'), findsOneWidget);
    expect(find.text('Open site'), findsNothing);
    expect(find.text('See all options'), findsOneWidget);

    await tester.tap(find.text('See all options'));
    await tester.pumpAndSettle();
    expect(find.text('Open site'), findsOneWidget);
    expect(find.text('Call us'), findsOneWidget);
  });

  testWidgets('renders carousel cards with sample values and dots', (
    tester,
  ) async {
    const template = Template(
      id: 't2',
      body: 'Check these out',
      carouselCards: [
        TemplateCarouselCard(
          headerFormat: 'IMAGE',
          body: 'Get {{1}} off',
          bodyExample: [
            ['20%'],
          ],
          buttons: [
            {'type': 'QUICK_REPLY', 'text': 'I want this'},
          ],
        ),
        TemplateCarouselCard(
          headerFormat: 'IMAGE',
          body: 'Second card',
          buttons: [
            {'type': 'QUICK_REPLY', 'text': 'More info'},
          ],
        ),
      ],
    );
    await tester.pumpWidget(
      _host(
        _message(templateId: 't2', body: 'Check these out'),
        template: template,
      ),
    );
    await tester.pumpAndSettle();

    // Shared bubble message + first card with its stored sample substituted.
    expect(find.text('Check these out'), findsOneWidget);
    expect(find.text('Get 20% off'), findsOneWidget);
    expect(find.text('I want this'), findsOneWidget);
  });

  testWidgets('preview renders a TEXT header, live body, and footer', (
    tester,
  ) async {
    const template = Template(
      id: 'p1',
      headerFormat: 'TEXT',
      headerText: 'Order {{1}}',
      headerExample: ['#12345'],
      body: 'Hi {{1}}',
      footerText: 'Thanks for shopping',
    );
    await tester.pumpWidget(_previewHost(template, 'Hi Ebrahim'));
    await tester.pumpAndSettle();

    // TEXT header fills from its stored example; body shows the live-filled
    // value; footer renders — none of which the old chip-only preview did.
    expect(find.text('Order #12345'), findsOneWidget);
    expect(find.text('Hi Ebrahim'), findsOneWidget);
    expect(find.text('Thanks for shopping'), findsOneWidget);
  });

  testWidgets('preview renders a media-header tile and buttons', (
    tester,
  ) async {
    const template = Template(
      id: 'p2',
      headerFormat: 'IMAGE',
      body: 'Deal {{1}}',
      buttons: [
        {'type': 'QUICK_REPLY', 'text': 'Claim'},
      ],
    );
    await tester.pumpWidget(_previewHost(template, 'Deal 50% off'));
    await tester.pumpAndSettle();

    // Media header shows a full tile (icon), body is live-filled, and the
    // button row renders — the old preview showed a chip and no buttons.
    expect(find.byIcon(Icons.image_rounded), findsOneWidget);
    expect(find.text('Deal 50% off'), findsOneWidget);
    expect(find.text('Claim'), findsOneWidget);
  });

  testWidgets('media header sits closer to the edges than the body text', (
    tester,
  ) async {
    const template = Template(
      id: 'p3',
      headerFormat: 'IMAGE',
      body: 'Body copy',
      footerText: 'Footer copy',
    );
    // sidePadding insets the body but not the media header.
    await tester.pumpWidget(
      _previewHost(template, 'Body copy', sidePadding: 8),
    );
    await tester.pumpAndSettle();

    final mediaLeft = tester
        .getTopLeft(
          find
              .ancestor(
                of: find.byIcon(Icons.image_rounded),
                matching: find.byType(Container),
              )
              .first,
        )
        .dx;
    final footerLeft = tester.getTopLeft(find.text('Footer copy')).dx;
    expect(mediaLeft, lessThan(footerLeft));
  });

  testWidgets('a leading media header hugs the top; a text header keeps inset', (
    tester,
  ) async {
    // Media header leads → topPadding is skipped, so it sits at the top edge.
    const media = Template(id: 'p4', headerFormat: 'IMAGE', body: 'Body');
    await tester.pumpWidget(_previewHost(media, 'Body', topPadding: 8));
    await tester.pumpAndSettle();
    final mediaTop = tester
        .getTopLeft(
          find
              .ancestor(
                of: find.byIcon(Icons.image_rounded),
                matching: find.byType(Container),
              )
              .first,
        )
        .dy;

    // Text header leads → topPadding insets it, holding the body's top padding.
    const text = Template(
      id: 'p5',
      headerFormat: 'TEXT',
      headerText: 'Hello header',
      body: 'Body',
    );
    await tester.pumpWidget(_previewHost(text, 'Body', topPadding: 8));
    await tester.pumpAndSettle();
    final headerTop = tester.getTopLeft(find.text('Hello header')).dy;

    expect(mediaTop, lessThan(headerTop));
  });
}
