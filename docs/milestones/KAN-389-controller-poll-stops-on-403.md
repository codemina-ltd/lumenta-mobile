# KAN-389 — Conversation-controller poll keeps running after a 403

**Ticket:** [KAN-389](https://codemina-ltd.atlassian.net/browse/KAN-389) (bug, filed by the log watcher as a possible regression of KAN-380)

## Findings

The ticket listed three possible causes. Each was checked:

1. **Portal fix not deployed — ruled out.** The live production bundle was
   downloaded on 2026-11-23 and contains the KAN-380 code
   (`pollingInterval: forbidden ? 0 : 30000` and the `onAccessLost` prop).
   Commit `4aa487f3` is on `origin/main` and first shipped in `v21.100.0`
   (2026-11-18), three days before the capture.
2. **Regression in the portal header poll — ruled out.** KAN-380 left the
   header's 30 s path without a test. Three tests now cover it and pass on the
   current code without any source change (see "What shipped").
3. **Another surface polls the route — confirmed, in the mobile app.** The
   portal has one caller (`ChatHeader`). The mobile chat screen is the other:
   `conversationControllerProvider` started a 30 s timer before each request,
   so it re-polled whatever the answer was. Riverpod 3's default automatic
   retry also applied, so a failed lookup was repeated up to 10 times with
   backoff. Measured in a test on the old code: 9 requests in the first 29 s
   after a 403, then the cycle repeats for as long as the chat stays open.

**What this does not establish:** which client produced the exact series in
the capture. That series was one request every ~31 s, which fits a
background browser tab on a pre-fix bundle (Chrome aligns background timers
to 1 s) better than the mobile burst pattern. The log lines carry no user
agent, so this is an inference. The mobile defect is real either way and
breaks the second acceptance criterion.

## What shipped

### Mobile (`mobile`)

- `lib/features/chats/chat_providers.dart`
  - The next poll is scheduled only after a lookup finishes, and not at all
    when it was answered 403.
  - Automatic retry is off for this provider; the 30 s timer is the only
    cadence. Other failures (network, 5xx) are tried again on that cadence.
  - New `isForbiddenError` helper.
  - The lookup runs again when the chat is reopened (the provider is
    auto-dispose) or after a successful send (existing invalidation).
- `lib/features/chats/widgets/controller_chip.dart` — the chip is hidden
  after a 403 instead of showing a state that will no longer refresh.
- `test/conversation_controller_poll_test.dart` — new: normal 30 s polling;
  403 on the first lookup; 403 on a later poll; transient failure recovers.
  Three of the four fail on the previous code.

### Portal (`portal`) — tests only

- `src/pages/ChatDetail/ChatDetail.accessLost.test.tsx` — three tests for the
  header's 30 s controller poll: it keeps polling while the route answers; it
  stops after a 403 that is not the client-access restriction; it stops and
  locks the chat when it is the first query to see the restriction.

## Verification

- Mobile: `flutter test` — 107 tests pass. `flutter analyze` — no errors or
  warnings; the only infos are the existing `material.dart` deprecation
  notices.
- Portal: the access-lost test file passes (4 tests); `yarn lint` — 0 errors.
  `yarn build` and the full portal suite were not run, because only a test
  file changed.

**Not exercised**

- No simulator run. Reproducing needs a member whose client access is
  restricted, and mobile login is reCAPTCHA-gated; the behaviour is covered
  by the provider test only.
- No production log capture after the change.

## Follow-ups / caveats

- The mobile fix reaches users only with a new app release; installed builds
  keep the old behaviour until they update.
- The mobile chat screen does not show a request-access state when access
  ends, and its other per-client requests were not reviewed here.
- Browser tabs still on a pre-`v21.100.0` portal bundle keep polling until
  they reload. The portal's update prompt reloads them once the service
  worker sees the new version.
- After the next mobile release, repeat the 5-minute log capture. If the
  ~31 s series is still there, log the user agent for this route to identify
  the client.
- The bundle check fetched about 500 asset files from the production site in
  parallel; 16 of them were refused or timed out, which suggests a
  connection limit at the edge. Nothing else was affected.
