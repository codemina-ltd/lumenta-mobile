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

  group('Message.emailSubject', () {
    Message email({String? channelType = 'email', Object? subject}) => Message(
      id: 'm1',
      direction: MessageDirection.inbound,
      body: 'Thanks, see you then.',
      channelType: channelType,
      channelPayload: subject == null ? null : {'subject': subject},
      createdAt: '2026-07-26T10:00:00Z',
    );

    test('reads channel_payload.subject on email rows, trimmed', () {
      expect(email(subject: ' Re: Invoice #42 ').emailSubject, 'Re: Invoice #42');
    });

    test('null when absent, empty, or not a string', () {
      expect(email().emailSubject, isNull);
      expect(email(subject: '   ').emailSubject, isNull);
      expect(email(subject: 7).emailSubject, isNull);
    });

    test('null on non-email channels even with a subject-shaped payload', () {
      expect(
        email(channelType: 'instagram', subject: 'Hello').emailSubject,
        isNull,
      );
      expect(email(channelType: null, subject: 'Hello').emailSubject, isNull);
    });
  });

  group('Message.quickReplies', () {
    Message withPayload(Map<String, dynamic>? payload) => Message(
      id: 'm1',
      direction: MessageDirection.outbound,
      body: 'Pick an option',
      channelType: 'instagram',
      channelPayload: payload,
      createdAt: '2026-07-27T10:00:00Z',
    );

    test('reads the offered titles, trimmed', () {
      expect(
        withPayload({
          'quick_replies': [
            {'title': ' Pricing ', 'payload': 'MENU_1'},
            {'title': 'Support', 'payload': 'MENU_2'},
          ],
        }).quickReplies,
        ['Pricing', 'Support'],
      );
    });

    test('null when the payload carries no usable quick replies', () {
      expect(withPayload(null).quickReplies, isNull);
      expect(withPayload({'quick_replies': []}).quickReplies, isNull);
      expect(withPayload({'quick_replies': 'nope'}).quickReplies, isNull);
      expect(
        withPayload({
          'quick_replies': [
            {'payload': 'MENU_1'},
            {'title': '   '},
            {'title': 7},
            'garbage',
          ],
        }).quickReplies,
        isNull,
      );
    });

    test('malformed entries are skipped, not fatal', () {
      expect(
        withPayload({
          'quick_replies': [
            {'payload': 'MENU_1'},
            {'title': 'Talk to a human', 'payload': 'MENU_2'},
            'garbage',
          ],
        }).quickReplies,
        ['Talk to a human'],
      );
    });
  });
}
