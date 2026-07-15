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
      body: TemplateMessageContent(
        message: message,
        textColor: Colors.black,
      ),
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
    await tester.pumpWidget(_host(_message(templateId: 't1'), template: template));
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
      _host(_message(templateId: 't2', body: 'Check these out'), template: template),
    );
    await tester.pumpAndSettle();

    // Shared bubble message + first card with its stored sample substituted.
    expect(find.text('Check these out'), findsOneWidget);
    expect(find.text('Get 20% off'), findsOneWidget);
    expect(find.text('I want this'), findsOneWidget);
  });
}
