import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/data/models/message.dart';

Message _msg(MessageType type, String body) => Message(
  id: 'm1',
  direction: MessageDirection.inbound,
  messageType: type,
  body: body,
  createdAt: '2026-07-16T10:00:00Z',
);

void main() {
  group('Message.mediaCaption', () {
    test('server placeholders are not captions', () {
      expect(_msg(MessageType.image, '[Image]').mediaCaption, isNull);
      expect(_msg(MessageType.video, '[Video]').mediaCaption, isNull);
      expect(_msg(MessageType.audio, '[Audio]').mediaCaption, isNull);
      expect(_msg(MessageType.sticker, '[Sticker]').mediaCaption, isNull);
      expect(_msg(MessageType.document, '[Document]').mediaCaption, isNull);
      expect(
        _msg(MessageType.document, '[Document: report.pdf]').mediaCaption,
        isNull,
      );
    });

    test('authored captions pass through', () {
      expect(
        _msg(MessageType.image, 'Look at this').mediaCaption,
        'Look at this',
      );
      expect(_msg(MessageType.video, 'Demo run').mediaCaption, 'Demo run');
    });

    test('empty body and non-media types yield null', () {
      expect(_msg(MessageType.image, '').mediaCaption, isNull);
      expect(_msg(MessageType.text, 'hello').mediaCaption, isNull);
    });
  });

  group('Message.documentFilename', () {
    test('parses the [Document: name] body', () {
      expect(
        _msg(MessageType.document, '[Document: report Q3.pdf]')
            .documentFilename,
        'report Q3.pdf',
      );
    });

    test('null for captions, bare placeholder, and other types', () {
      expect(
        _msg(MessageType.document, 'here is the file').documentFilename,
        isNull,
      );
      expect(_msg(MessageType.document, '[Document]').documentFilename, isNull);
      expect(
        _msg(MessageType.image, '[Document: x.pdf]').documentFilename,
        isNull,
      );
    });
  });
}
