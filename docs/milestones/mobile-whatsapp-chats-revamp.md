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

## Follow-up: floating glass dock

The dock now floats over the content like WhatsApp's: `HomeShell` uses
`extendBody: true`; `AppNavBar` is liquid glass — a 28px `BackdropFilter`
blur composed with a mild saturation matrix, a white specular gradient tint
(0.62→0.30 light, 0.16→0.06 dark), a painted top-left-bright gradient rim,
a white glass pill behind the active tab, shadow outside the clip — and every
tab list adds `MediaQuery.paddingOf(context).bottom` so the last row scrolls
clear of the dock. Verified on the simulator mid-scroll in
light and dark mode (rows visibly blur through the dock).

## Follow-up: WhatsApp-style composer with hold-to-record voice notes

`ChatComposer` row is now `+ · message pill · camera · mic` (the mic becomes
the send arrow once there is text; the camera opens the camera directly).
Voice notes (`widgets/voice_recorder.dart`, package `record` 7.x):

- **Hold** the mic → recording starts instantly (raw `Listener`, no
  long-press delay): pulsing red mic, running clock, "Slide to cancel ‹"
  that trails the finger, lock pill floating above the enlarged mic.
- **Slide toward the start edge** past 110 px → cancel (RTL-aware);
  **slide up** past 70 px → **locked** hands-free mode.
- **Locked panel**: clock + live waveform (amplitude polled every 90 ms,
  dBFS → 0..1, 48 bars), then delete · pause/resume · send.
- **Release** while holding sends; a tap shorter than 1 s is discarded with a
  "Hold to record, release to send" hint. Mic permission denied → hint.
- Clip is mono AAC `.m4a` (64 kbps) sent via `POST /messages/send-media` with
  `mediaType=audio`, `voiceNote=true`, `Content-Type: audio/mp4`; the API
  re-encodes to OGG/Opus so WhatsApp shows a voice bubble. Thread gets the
  usual optimistic audio bubble.
- `VoiceRecorderController` is a `ChangeNotifier` state machine
  (idle / holding / locked, paused, elapsed, samples, drag progress) that the
  composer drives from pointer events; injectable for tests and previews.
  Android gains `RECORD_AUDIO`; iOS already declared the mic usage string.

Verified: 8 unit tests with a fake `RecordPlatform` (send, too-short tap,
LTR/RTL slide-to-cancel, slide-up lock + pause/resume/finish, amplitude
normalisation/cap, permission denied); simulator screenshots of idle,
holding, sliding, locked (waveform), paused, driven through the injected
controller with the simulator mic pre-granted via `simctl privacy`.
Not exercised: a real device recording round-trip through the API.

## Remaining caveats

- Against an API predating this change the app degrades: no pins (the pin
  action shows "Something went wrong"), unread falls back to the on-device
  cursor with a badge of 1, outbound rows show a single tick.
- Unread for a never-opened chat counts *all* its inbound messages (same
  semantics as before); opening it once resets the cursor.
- `navInbox` strings stay in the ARBs for the inbox's return.
- Notifications empty state shows the same string as title and body
  (pre-existing).
