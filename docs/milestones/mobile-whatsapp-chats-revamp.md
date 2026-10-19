# Mobile — WhatsApp-style revamp (chats, nav, pins, New chat)

**Ticket:** none (direct request, 2026-10-19). **Repo:** `mobile` only.

## What shipped

- **Bottom nav is now Chats · Reminders · You · Notifications.** Clients and
  Inbox tabs are gone. The dock is a floating pill (`AppNavBar`), and the You
  tab shows the signed-in user's picture/initials as its icon.
- **Per-tab masthead** (`TabHeader`): round action buttons above a large bold
  title, no Material app bar. Chats: `⋯` menu (Mark all as read, Clients,
  Switch workspace), search disc, green `+`. Notifications: mark-all-read disc
  while anything is unread. Reminders / You: title only.
- **Chats tab**
  - Filter pills **All / Unread N** (unread count is over the loaded pages;
    the Unread view keeps paging in while it looks thin).
  - **Pin chat** (WhatsApp-style): swipe start→end on a row, or long-press →
    sheet (Pin/Unpin, Mark as read, View profile). Pinned rows sit on top in
    pin order and show a pin glyph; unread rows show a green dot.
  - Row restyle: 54pt avatar, bold name, two-line preview, time on the end
    side (green when unread), single tick for outbound, channel glyph for
    non-WhatsApp channels. Arabic names stay start-aligned; previews follow
    their own script direction (as WhatsApp does).
- **New chat sheet** (`+`): search box (server client search, debounced,
  paginated), "Search messages, notes and more" shortcut to global search,
  **Recent chats** (top 5 from the chats list) and **All clients** in iOS-style
  grouped cards. Tapping a client opens `/chats/:clientId`.
- **You tab** (`YouScreen`): identity card → Profile, Account (Profile,
  Clients), Workspace (active workspace + Switch workspace when the user has
  several, Log out). Log out still deregisters the push device first.
- **Inbox removed from mobile** (routes/nav only — the feature code stays).
  Thread-only pushes that used to land on `/inbox` now land on `/chats`.
- **Clients directory** survives as a root route `/clients` (`ClientsPage`),
  reached from the You tab, the chats `⋯` menu, and still used by deep links.

## Files

- New: `lib/data/storage/pinned_chats_store.dart`,
  `lib/features/chats/chat_list_logic.dart`,
  `lib/features/chats/new_chat_controller.dart`,
  `lib/features/chats/widgets/new_chat_sheet.dart`,
  `lib/features/shell/tab_header.dart`, `lib/features/you/you_screen.dart`,
  `test/chat_list_logic_test.dart`.
- Changed: `lib/core/router/app_router.dart` (4 branches, root `/clients`),
  `lib/features/shell/home_shell.dart`, `lib/features/shell/app_nav_bar.dart`,
  `lib/features/chats/chats_screen.dart`,
  `lib/features/clients/clients_screen.dart` (`ClientsPage` wrapper),
  `lib/data/storage/last_read_store.dart` (`markAllRead`),
  `lib/features/push/push_service.dart` (`/inbox` → `/chats`),
  `lib/main.dart` (hydrate pins), ARB en/ar/fr + regenerated l10n, `CLAUDE.md`.

## Verification

- `flutter analyze`: clean. `flutter test`: 87/87 (5 new unit tests for the
  pinned-first ordering, unread filter and unread count).
- iOS Simulator (iPhone 17 Pro, iOS 27) with a temporary fake-data entrypoint
  (login is reCAPTCHA-gated in dev; entrypoint deleted after use): Chats tab
  light + dark, Unread filter, New chat sheet, You tab, Notifications header.
  Two layout bugs found and fixed this way (centered lone title; sheet close
  button overlapping the title).
- Not exercised visually: swipe/long-press row actions (no input injection
  headless) and real API data — the logic they call is unit-tested and the
  sheet is plain `ListTile`s.

## Follow-up (same day): server-backed pins, counts and ticks

The first cut kept pins and unread on-device, which left four caveats
(boolean unread, one tick for every outbound row, pinned chats outside the
loaded pages not hoisted, pins not syncing across devices). Resolved by
moving that state into the API — see
`api/docs/milestones/mobile-conversation-member-state.md`:

- **Pins** → `PUT/DELETE /messages/conversations/:clientId/pin`; the server
  sorts pinned first across pagination. `pinned_chats_store.dart` removed.
- **Unread count badge** (WhatsApp green pill, `99+` cap) from the server's
  per-member `unreadCount`; the "Unread N" chip reads
  `meta.unreadConversations` (member-wide, not just loaded pages).
- **Unread filter** is now a server filter (`?unread=true`): `ChatsController`
  became a family keyed by `ChatFilter`, so All and Unread page independently;
  pin/read mutations are optimistic on the active list and invalidate the
  sibling.
- **Delivery ticks** on the row from `lastMessageStatus` (one tick sent, two
  delivered, two lilac read, ember error failed), mirroring the bubble meta.
- **Read cursor** is advanced on the server when a thread loads
  (`POST /messages/conversations/read`) and by Mark as read / Mark all as
  read; the on-device cursor is kept as a fallback for older servers and for
  instant badges.

Verified again on the simulator with the fake-data entrypoint (scripted pin +
mark-read → row hoisted, chip 6 → 5; Unread view; count badges and ticks).

## Remaining caveats

- Against an API predating this change the app degrades: no pins (the pin
  action shows "Something went wrong"), unread falls back to the on-device
  cursor with a badge of 1, outbound rows show a single tick.
- Unread for a never-opened chat counts *all* its inbound messages (same
  semantics as before); opening it once resets the cursor.
- `navInbox` strings stay in the ARBs for the inbox's return.
- Notifications empty state shows the same string as title and body
  (pre-existing).
