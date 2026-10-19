import '../../data/models/conversation.dart';
import '../../data/models/message.dart';
import '../../data/storage/last_read_store.dart';
import '../../data/storage/pinned_chats_store.dart';

/// Top filter chips on the chats tab (WhatsApp "All / Unread").
enum ChatFilter { all, unread }

/// A chat is unread when its last message is inbound and newer than the
/// on-device last-read cursor for that client.
bool conversationIsUnread(Conversation conv, LastReadState lastRead) =>
    conv.lastMessageDirection == MessageDirection.inbound &&
    lastRead.isUnread(conv.clientId, conv.lastMessageAtDate);

/// Arranges the loaded conversations for display: pinned chats first (in pin
/// order, most recently pinned on top), then the rest in the server's
/// recency order; then applies [filter].
///
/// Pure so it can be unit-tested; the screen passes the live stores in.
/// Pinned chats that haven't been paged in yet can't be hoisted — pins are
/// on-device, so the server can't sort by them.
List<Conversation> arrangeConversations(
  List<Conversation> items, {
  required PinnedChatsState pinned,
  required LastReadState lastRead,
  ChatFilter filter = ChatFilter.all,
}) {
  final pinnedRows = <Conversation>[];
  final rest = <Conversation>[];
  for (final c in items) {
    (pinned.isPinned(c.clientId) ? pinnedRows : rest).add(c);
  }
  pinnedRows.sort(
    (a, b) => pinned.rank(a.clientId)!.compareTo(pinned.rank(b.clientId)!),
  );
  final ordered = [...pinnedRows, ...rest];
  if (filter == ChatFilter.all) return ordered;
  return [
    for (final c in ordered)
      if (conversationIsUnread(c, lastRead)) c,
  ];
}

/// Number of unread chats among [items] (drives the "Unread N" chip).
int countUnread(List<Conversation> items, LastReadState lastRead) =>
    items.where((c) => conversationIsUnread(c, lastRead)).length;
