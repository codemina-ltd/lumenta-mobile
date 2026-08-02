import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/i18n/arb/app_localizations.dart';
import 'package:mobile/data/models/channel_thread.dart';
import 'package:mobile/data/models/conversation_sender.dart';
import 'package:mobile/data/models/sender.dart';
import 'package:mobile/features/chats/widgets/sender_thread_bar.dart';

ChannelThread _thread({
  String id = 'ct1',
  String channelType = 'instagram',
  String? accountDisplayName = '@acme.shop',
}) => ChannelThread(
  id: id,
  channelType: channelType,
  channelAccountId: 'acc-$id',
  accountDisplayName: accountDisplayName,
  accountStatus: 'active',
);

Widget _host({
  List<ConversationSender> conversationSenders = const [],
  List<Sender> senders = const [],
  String? activeSenderId,
  List<ChannelThread> channelThreads = const [],
  String? activeChannelThreadId,
  ValueChanged<String>? onSelectChannel,
}) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(
    body: SenderThreadBar(
      conversationSenders: conversationSenders,
      senders: senders,
      activeSenderId: activeSenderId,
      onSelect: (_) {},
      channelThreads: channelThreads,
      activeChannelThreadId: activeChannelThreadId,
      onSelectChannel: onSelectChannel,
    ),
  ),
);

void main() {
  testWidgets('renders a channel pill with the account display name', (
    tester,
  ) async {
    await tester.pumpWidget(_host(channelThreads: [_thread()]));
    await tester.pumpAndSettle();
    expect(find.text('@acme.shop'), findsOneWidget);
    expect(find.byIcon(Icons.camera_alt_outlined), findsOneWidget);
  });

  testWidgets('falls back to the localized channel name without one', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        channelThreads: [
          _thread(channelType: 'messenger', accountDisplayName: null),
        ],
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Messenger'), findsOneWidget);
  });

  testWidgets('tapping a channel pill reports its thread id', (tester) async {
    String? selected;
    await tester.pumpWidget(
      _host(
        channelThreads: [_thread(), _thread(id: 'ct2', channelType: 'email')],
        onSelectChannel: (id) => selected = id,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.mail_outline));
    expect(selected, 'ct2');
  });
}
