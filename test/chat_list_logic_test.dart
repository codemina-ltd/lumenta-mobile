import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/data/models/conversation.dart';
import 'package:mobile/data/models/message.dart';
import 'package:mobile/data/storage/last_read_store.dart';
import 'package:mobile/data/storage/pinned_chats_store.dart';
import 'package:mobile/features/chats/chat_list_logic.dart';

Conversation _conv(
  String id, {
  required DateTime at,
  MessageDirection direction = MessageDirection.inbound,
}) => Conversation(
  clientId: id,
  name: 'Client $id',
  lastMessageAt: at.toUtc().toIso8601String(),
  lastMessageDirection: direction,
  lastMessageType: MessageType.text,
  lastMessageBody: 'hi',
);

void main() {
  final t0 = DateTime(2026, 10, 19, 12);
  // Server order: newest first.
  final items = [
    _conv('a', at: t0),
    _conv('b', at: t0.subtract(const Duration(hours: 1))),
    _conv('c', at: t0.subtract(const Duration(hours: 2))),
    _conv(
      'd',
      at: t0.subtract(const Duration(hours: 3)),
      direction: MessageDirection.outbound,
    ),
  ];
  const noPins = PinnedChatsState([]);
  const nothingRead = LastReadState({});

  group('arrangeConversations', () {
    test('keeps server order when nothing is pinned', () {
      final rows = arrangeConversations(
        items,
        pinned: noPins,
        lastRead: nothingRead,
      );
      expect(rows.map((c) => c.clientId), ['a', 'b', 'c', 'd']);
    });

    test('hoists pinned chats to the top in pin order', () {
      // 'c' was pinned most recently, then 'd'.
      const pins = PinnedChatsState(['c', 'd']);
      final rows = arrangeConversations(
        items,
        pinned: pins,
        lastRead: nothingRead,
      );
      expect(rows.map((c) => c.clientId), ['c', 'd', 'a', 'b']);
    });

    test('ignores pins for chats that are not loaded', () {
      const pins = PinnedChatsState(['zzz', 'b']);
      final rows = arrangeConversations(
        items,
        pinned: pins,
        lastRead: nothingRead,
      );
      expect(rows.map((c) => c.clientId), ['b', 'a', 'c', 'd']);
    });

    test('unread filter keeps inbound chats newer than the read cursor', () {
      final lastRead = LastReadState({
        // 'b' read after its last message → not unread.
        'b': t0.toIso8601String(),
        // 'c' read before its last message → still unread.
        'c': t0.subtract(const Duration(hours: 5)).toIso8601String(),
      });
      final rows = arrangeConversations(
        items,
        pinned: const PinnedChatsState(['c']),
        lastRead: lastRead,
        filter: ChatFilter.unread,
      );
      // 'd' is outbound, so never unread; pinned 'c' still leads.
      expect(rows.map((c) => c.clientId), ['c', 'a']);
      expect(countUnread(items, lastRead), 2);
    });
  });

  group('PinnedChatsState', () {
    test('rank reflects pin order and null when unpinned', () {
      const pins = PinnedChatsState(['x', 'y']);
      expect(pins.isPinned('x'), isTrue);
      expect(pins.rank('y'), 1);
      expect(pins.rank('nope'), isNull);
    });
  });
}
