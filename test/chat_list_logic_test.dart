import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/data/models/conversation.dart';
import 'package:mobile/data/models/message.dart';
import 'package:mobile/data/storage/last_read_store.dart';
import 'package:mobile/features/chats/chat_list_logic.dart';

Conversation _conv(
  String id, {
  required DateTime at,
  MessageDirection direction = MessageDirection.inbound,
  int? unreadCount,
  DateTime? pinnedAt,
}) => Conversation(
  clientId: id,
  name: 'Client $id',
  lastMessageAt: at.toUtc().toIso8601String(),
  lastMessageDirection: direction,
  lastMessageType: MessageType.text,
  lastMessageBody: 'hi',
  unreadCount: unreadCount,
  pinnedAt: pinnedAt?.toUtc().toIso8601String(),
);

void main() {
  final t0 = DateTime(2026, 10, 19, 12);
  const nothingRead = LastReadState({});

  group('arrangeConversations', () {
    // Server order: newest first.
    final items = [
      _conv('a', at: t0, unreadCount: 2),
      _conv('b', at: t0.subtract(const Duration(hours: 1)), unreadCount: 0),
      _conv(
        'c',
        at: t0.subtract(const Duration(hours: 2)),
        unreadCount: 5,
        pinnedAt: t0.subtract(const Duration(days: 1)),
      ),
      _conv(
        'd',
        at: t0.subtract(const Duration(hours: 3)),
        direction: MessageDirection.outbound,
        unreadCount: 0,
        pinnedAt: t0.subtract(const Duration(days: 2)),
      ),
    ];

    test('hoists pinned chats to the top, most recently pinned first', () {
      final rows = arrangeConversations(items, lastRead: nothingRead);
      expect(rows.map((c) => c.clientId), ['c', 'd', 'a', 'b']);
    });

    test('unread filter keeps chats with a server unread count', () {
      final rows = arrangeConversations(
        items,
        lastRead: nothingRead,
        filter: ChatFilter.unread,
      );
      expect(rows.map((c) => c.clientId), ['c', 'a']);
      expect(countUnread(items, nothingRead), 2);
    });
  });

  group('unread fallback (servers without unreadCount)', () {
    final legacy = [
      _conv('x', at: t0),
      _conv('y', at: t0.subtract(const Duration(hours: 1))),
      _conv(
        'z',
        at: t0.subtract(const Duration(hours: 2)),
        direction: MessageDirection.outbound,
      ),
    ];

    test('uses the on-device cursor and a badge of 1', () {
      final lastRead = LastReadState({
        // read after its last message → not unread
        'y': t0.toIso8601String(),
      });
      expect(conversationIsUnread(legacy[0], lastRead), isTrue);
      expect(conversationIsUnread(legacy[1], lastRead), isFalse);
      expect(conversationIsUnread(legacy[2], lastRead), isFalse);
      expect(unreadBadgeCount(legacy[0], lastRead), 1);
      expect(unreadBadgeCount(legacy[1], lastRead), 0);
      final rows = arrangeConversations(
        legacy,
        lastRead: lastRead,
        filter: ChatFilter.unread,
      );
      expect(rows.map((c) => c.clientId), ['x']);
    });

    test('server count wins over the local cursor', () {
      final lastRead = LastReadState({'a': t0.toIso8601String()});
      final conv = _conv('a', at: t0, unreadCount: 4);
      expect(conversationIsUnread(conv, lastRead), isTrue);
      expect(unreadBadgeCount(conv, lastRead), 4);
      expect(unreadBadgeCount(_conv('b', at: t0, unreadCount: 0), lastRead), 0);
    });
  });

  test('Conversation pin accessors', () {
    final pinned = _conv('p', at: t0, pinnedAt: t0);
    expect(pinned.isPinned, isTrue);
    expect(pinned.pinnedAtDate, isNotNull);
    expect(_conv('q', at: t0).isPinned, isFalse);
  });
}
