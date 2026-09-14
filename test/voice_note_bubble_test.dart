import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/i18n/arb/app_localizations.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/theme/app_dimens.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/data/models/message.dart';
import 'package:mobile/features/chats/widgets/voice_note_bubble.dart';

Message _msg({
  required bool outbound,
  String body = '',
  String? transcription,
  String? transcriptionStatus,
  String? ttsProvider,
}) => Message(
  id: outbound ? 'out-1' : 'in-1',
  direction: outbound ? MessageDirection.outbound : MessageDirection.inbound,
  status: MessageStatus.sent,
  messageType: MessageType.audio,
  body: body,
  mediaMimeType: 'audio/ogg',
  transcription: transcription,
  transcriptionStatus: transcriptionStatus,
  ttsProvider: ttsProvider,
  createdAt: '2026-09-14T03:36:00Z',
);

Future<Uint8List?> _noBytes() async => null;

Widget _bubble(BuildContext context, Message m) {
  final chat = context.chat;
  final outbound = m.isOutbound;
  final isLight = context.scheme.brightness == Brightness.light;
  return Align(
    alignment: outbound ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      constraints: const BoxConstraints(maxWidth: 300),
      margin: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: 3),
      padding: const EdgeInsets.fromLTRB(Insets.md, Insets.sm, Insets.md, 6),
      decoration: BoxDecoration(
        color: outbound ? chat.outboundBubble : chat.inboundBubble,
        borderRadius: BorderRadius.circular(Radii.md),
        border: (!outbound && isLight)
            ? Border.all(color: AppColors.hairline)
            : null,
      ),
      child: VoiceNoteContent(
        message: m,
        textColor: outbound ? chat.outboundText : chat.inboundText,
        loadBytes: _noBytes,
      ),
    ),
  );
}

Widget _harness(ThemeData base) {
  // Point every text style at the face loaded in [_loadRealFonts] so the
  // golden shows real Latin + Arabic glyphs instead of Ahem blocks.
  final theme = base.copyWith(
    textTheme: base.textTheme.apply(fontFamily: 'TestFace'),
  );
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: theme,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: Builder(
        builder: (context) => ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            _bubble(
              context,
              _msg(
                outbound: false,
                transcription: 'ممكن تساعدني اعمل سيتاب للاكاونت بتاعي ؟',
                transcriptionStatus: 'ready',
              ),
            ),
            _bubble(
              context,
              _msg(
                outbound: true,
                ttsProvider: 'elevenlabs',
                body:
                    'أيوه، أقدر أساعدك تعمل إعداد للاكاونت. ابدأ بتسجيل الدخول للبوابة.',
              ),
            ),
            _bubble(
              context,
              _msg(outbound: false, transcriptionStatus: 'in_progress'),
            ),
            _bubble(
              context,
              _msg(outbound: false, transcriptionStatus: 'not_applicable'),
            ),
          ],
        ),
      ),
    ),
  );
}

Future<void> _loadRealFonts() async {
  // flutter_test renders text with the block "Ahem" font unless real font
  // data is registered; load a Latin+Arabic system face under the theme's
  // family name plus the Material icon font so the golden is legible.
  Future<void> load(String family, String path) async {
    final f = File(path);
    if (!f.existsSync()) return;
    final bytes = await f.readAsBytes();
    final loader = FontLoader(family)
      ..addFont(Future.value(ByteData.view(bytes.buffer)));
    await loader.load();
  }

  await load(
    'TestFace',
    '/System/Library/Fonts/Supplemental/Arial Unicode.ttf',
  );
  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot != null) {
    await load(
      'MaterialIcons',
      '$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
    );
  }
}

void main() {
  setUpAll(_loadRealFonts);

  testWidgets('voice-note bubbles render transcript, reply and states', (
    tester,
  ) async {
    await tester.pumpWidget(_harness(AppTheme.light));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Transcribed by Lume'), findsOneWidget);
    expect(find.text('Lume voice reply'), findsOneWidget);
    expect(find.text('Lume is transcribing…'), findsOneWidget);
    expect(
      find.text('ممكن تساعدني اعمل سيتاب للاكاونت بتاعي ؟'),
      findsOneWidget,
    );
    // Speed chip + play button on every player.
    expect(find.text('1×'), findsNWidgets(4));
    expect(find.bySemanticsLabel('Play voice note'), findsNWidgets(4));
  });
}
