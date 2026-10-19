import '../../data/models/conversation.dart';
import '../../data/models/message.dart';
import '../../data/storage/last_read_store.dart';

/// Top filter chips on the chats tab (WhatsApp "All / Unread").
enum ChatFilter { all, unread }

/// Whether a chat has unread inbound messages.
///
/// The server's per-member `unreadCount` is authoritative when present;
/// servers predating it return null and the on-device last-read cursor
/// decides (last message inbound and newer than the cursor).
bool conversationIsUnread(Conversation conv, LastReadState lastRead) {
  final count = conv.unreadCount;
  if (count != null) return count > 0;
  return conv.lastMessageDirection == MessageDirection.inbound &&
      lastRead.isUnread(conv.clientId, conv.lastMessageAtDate);
}

/// Number to print in the row's unread badge: the server count, or 1 when
/// only the local cursor knows the chat is unread; 0 when read.
int unreadBadgeCount(Conversation conv, LastReadState lastRead) {
  final count = conv.unreadCount;
  if (count != null) return count < 0 ? 0 : count;
  return conversationIsUnread(conv, lastRead) ? 1 : 0;
}

/// Arranges conversations for display: pinned chats first (most recently
/// pinned on top), then the rest in the server's recency order; then applies
/// [filter] client-side.
///
/// The server already returns pages in this order; the client re-applies it
/// so optimistic pin/unpin edits reorder instantly, and so a stale page from
/// an older server still renders sensibly.
List<Conversation> arrangeConversations(
  List<Conversation> items, {
  required LastReadState lastRead,
  ChatFilter filter = ChatFilter.all,
}) {
  final pinned = <Conversation>[];
  final rest = <Conversation>[];
  for (final c in items) {
    (c.isPinned ? pinned : rest).add(c);
  }
  pinned.sort((a, b) {
    final ad = a.pinnedAtDate;
    final bd = b.pinnedAtDate;
    if (ad == null || bd == null) return 0;
    return bd.compareTo(ad);
  });
  final ordered = [...pinned, ...rest];
  if (filter == ChatFilter.all) return ordered;
  return [
    for (final c in ordered)
      if (conversationIsUnread(c, lastRead)) c,
  ];
}

/// Number of unread chats among [items] — the fallback for the "Unread N"
/// chip when the server doesn't report `unreadConversations`.
int countUnread(List<Conversation> items, LastReadState lastRead) =>
    items.where((c) => conversationIsUnread(c, lastRead)).length;
