import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/i18n/arb/app_localizations.dart';
import 'package:mobile/core/i18n/arb/app_localizations_ar.dart';
import 'package:mobile/core/i18n/arb/app_localizations_en.dart';
import 'package:mobile/core/i18n/arb/app_localizations_fr.dart';
import 'package:mobile/data/models/channel_thread.dart';
import 'package:mobile/data/models/message.dart';
import 'package:mobile/features/chats/widgets/channel_composer.dart';
import 'package:mobile/features/chats/widgets/channel_indicator.dart';
import 'package:mobile/features/shared/tenant_features.dart';

/// KAN-423 — Telegram in the mobile app.
void main() {
  final l10n = AppLocalizationsEn();

  ChannelThread thread(
    String channelType, {
    String? serviceWindowExpiresAt,
    String? lastInboundAt,
  }) => ChannelThread(
    id: 'thread-1',
    channelType: channelType,
    channelAccountId: 'acc-1',
    serviceWindowExpiresAt: serviceWindowExpiresAt,
    lastInboundAt: lastInboundAt,
    accountDisplayName: 'example_bot',
    accountStatus: 'active',
  );

  Message message(Map<String, dynamic> json) => Message.fromJson({
    'id': 'm1',
    'direction': 'inbound',
    'body': 'stored English text',
    'createdAt': '2026-01-01T00:00:00.000Z',
    ...json,
  });

  group('channel identity', () {
    test('Telegram has its own icon, colour and name', () {
      expect(channelIcon('telegram'), Icons.telegram);
      expect(channelIcon('telegram'), isNot(channelIcon('whatsapp')));
      expect(channelColor('telegram'), isNot(channelColor('whatsapp')));
      expect(channelLabel(l10n, 'telegram'), 'Telegram');
      expect(channelLabel(AppLocalizationsAr(), 'telegram'), 'تيليجرام');
      expect(channelLabel(AppLocalizationsFr(), 'telegram'), 'Telegram');
    });

    test('the other channels are unchanged', () {
      expect(channelLabel(l10n, 'instagram'), 'Instagram');
      expect(channelLabel(l10n, 'email'), 'Email');
      expect(channelLabel(l10n, 'whatsapp'), 'WhatsApp');
    });
  });

  group('feature flag', () {
    test('channel_telegram is one of the channel feature keys', () {
      expect(channelFeatureKeys, contains('channel_telegram'));
    });

    test('an explicit false hides Telegram; unknown or pending stays open', () {
      expect(
        channelFeatureEnabled({'channel_telegram': false}, 'telegram'),
        isFalse,
      );
      expect(
        channelFeatureEnabled({'channel_telegram': true}, 'telegram'),
        isTrue,
      );
      expect(channelFeatureEnabled(const {}, 'telegram'), isTrue);
      expect(channelFeatureEnabled(null, 'telegram'), isTrue);
    });

    test('threads are skipped only when every channel flag is off', () {
      final allOff = {for (final k in channelFeatureKeys) k: false};
      expect(allChannelFeaturesDisabled(allOff), isTrue);
      expect(
        allChannelFeaturesDisabled({...allOff, 'channel_telegram': true}),
        isFalse,
      );
    });
  });

  group('messaging window', () {
    test('Telegram has none; Instagram and Messenger do', () {
      expect(thread('telegram').hasMessagingWindow, isFalse);
      expect(thread('instagram').hasMessagingWindow, isTrue);
      expect(thread('messenger').hasMessagingWindow, isTrue);
    });
  });

  group('system notice', () {
    test('reads the Telegram event code from the channel payload', () {
      expect(
        message({
          'channelPayload': {
            'telegram': {'chat_id': '1', 'event': 'bot_blocked'},
          },
        }).telegramEvent,
        'bot_blocked',
      );
      expect(message({}).telegramEvent, isNull);
      expect(
        message({
          'channelPayload': {'telegram': 'not-a-map'},
        }).telegramEvent,
        isNull,
      );
    });

    test('is shown as a localized line, not the stored text', () {
      final blocked = message({
        'channelPayload': {
          'telegram': {'event': 'bot_blocked'},
        },
      });
      final unblocked = message({
        'channelPayload': {
          'telegram': {'event': 'bot_unblocked'},
        },
      });
      expect(telegramNoticeText(l10n, blocked), l10n.telegramBotBlocked);
      expect(telegramNoticeText(l10n, unblocked), l10n.telegramBotUnblocked);
      expect(
        telegramNoticeText(AppLocalizationsAr(), blocked),
        isNot(l10n.telegramBotBlocked),
      );
      expect(telegramNoticeText(l10n, message({})), isNull);
    });
  });

  group('ChannelComposer', () {
    Future<void> pump(WidgetTester tester, ChannelThread t) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: Align(
                alignment: Alignment.bottomCenter,
                child: ChannelComposer(
                  threadKey: (
                    clientId: 'c1',
                    senderId: null,
                    channelAccountId: 'acc-1',
                  ),
                  thread: t,
                  onSent: () {},
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
    }

    testWidgets(
      'a Telegram thread with no window data shows the input, not the closed notice',
      (tester) async {
        await pump(tester, thread('telegram'));

        expect(find.byType(TextField), findsOneWidget);
        expect(find.text(l10n.channelWindowClosed), findsNothing);
        expect(find.text(l10n.channelHumanAgentLabel), findsNothing);
      },
    );

    testWidgets('an Instagram thread with no window data is still closed', (
      tester,
    ) async {
      await pump(tester, thread('instagram'));

      expect(find.text(l10n.channelWindowClosed), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets(
      'an Instagram thread past 24 hours still offers the human-agent option',
      (tester) async {
        final twoDaysAgo = DateTime.now()
            .subtract(const Duration(days: 2))
            .toIso8601String();
        await pump(
          tester,
          thread(
            'instagram',
            serviceWindowExpiresAt: DateTime.now()
                .subtract(const Duration(days: 1))
                .toIso8601String(),
            lastInboundAt: twoDaysAgo,
          ),
        );

        expect(find.text(l10n.channelHumanAgentLabel), findsOneWidget);
      },
    );
  });
}
