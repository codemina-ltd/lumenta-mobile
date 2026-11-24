# KAN-423 — Telegram Phase 4: mobile app

**Ticket:** KAN-423 (epic KAN-410, Phase 4)
**Date:** 2026-11-24
**Repo:** `mobile`

## What shipped

- **Channel identity:** Telegram has its own icon (`Icons.telegram`), colour
  and localised name in `channel_indicator.dart`, which the chat list row,
  bubble meta row and channel thread tabs all share. The unrouted inbox
  screen's chip label is updated too.
- **Feature flag:** `channel_telegram` is one of the channel feature keys, so
  a Telegram thread tab is hidden when the flag is explicitly off.
- **Composer:** `ChannelThread.hasMessagingWindow` is false for Telegram. The
  channel composer treats such a thread as always open: the text input is
  shown, with no "window closed" notice and no "send as human agent" option.
  Before this change a Telegram thread showed the closed notice, because it
  has no window expiry.
- **System notice:** `Message.telegramEvent` reads the event code from the
  channel payload, and the bubble shows a localised line for "blocked" /
  "unblocked" instead of the English text the API stores.
- Strings in en / ar / fr, with the generated `AppLocalizations` files.

No `@freezed` field was added, so no `build_runner` run was needed: the two
new members are plain getters on the hand-written part of the models.

## Not in scope

- Sending files from the mobile channel composer (text only on mobile today,
  for every non-WhatsApp channel).
- Connecting or managing a bot from the app.

## Files

- `lib/features/chats/widgets/channel_indicator.dart`
- `lib/features/chats/widgets/channel_composer.dart`
- `lib/features/chats/chat_detail_screen.dart`
- `lib/features/shared/tenant_features.dart`
- `lib/features/inbox/inbox_screen.dart`
- `lib/data/models/channel_thread.dart`, `lib/data/models/message.dart`
- `lib/core/i18n/arb/app_{en,ar,fr}.arb` and generated
  `app_localizations*.dart`
- `test/telegram_channel_test.dart` (new), `test/tenant_features_test.dart`

## Verification

- `flutter test`: 118 tests passing. 11 are new (identity, flag, window,
  notice, and three composer widget tests). One existing test was updated: it
  listed the four channel flags and Telegram is now a fifth.
- `flutter analyze`: no errors or warnings. It reports 89 infos, all the
  "`material.dart` is deprecated" notice that every file in the repo gets on
  this Flutter version; one of them is the new test file. The ticket's
  "analyze is clean" is therefore not literally met, and was not before.
- iOS simulator (iPhone 17), real app against the dev API, through a
  temporary entrypoint that injected a dev session and opened one chat. The
  entrypoint was deleted afterwards and is not in the commit.
  - The Telegram conversation with the real test bot opens on its own tab
    with the Telegram glyph; bubbles carry the Telegram marker; the inbound
    photo renders; the composer is open and reads "Sending as lumentacobot".
  - A reply sent through the app's own send path (`sendChannelText`) was
    delivered by Telegram and stored as sent.
  - On the simulated conversation: the location card, the localised block
    notice in italics, and the placeholder for the photo whose download
    failed.
- **Not exercised:** typing and tapping Send by hand (no UI automation tool
  is installed for the simulator, so the send was triggered in code), voice
  note playback, the flag-off state on a device, Arabic and French layouts,
  and Android.

## Caveats and follow-ups

- For the simulator run, `mobile_login` was switched on for the dev smoke
  tenant and removed again afterwards.
- SMS and email threads in the mobile channel composer still go through the
  24-hour window check and so show the closed notice. The portal treats both
  as window-free. This predates this ticket and was left alone.
- The working tree had unrelated uncommitted changes (`pubspec`, generated
  `*.freezed.dart`, platform files). They are not part of this commit.
