# KAN-7 — Chat opened from a notification replaces the route

**Type:** Bug · **Status:** Fixed · **Date:** 2026-08-02 · **Platform:** Flutter mobile

## Ticket

> When a chat thread opens from the mobile app, it replaces the route; pressing
> back returns the user to the client's chat list.
>
> UAC:
> - It should avoid replacing the route and instead allow a pop.
> - It must return to the notification on pop.

## Root cause

Chat detail (`/chats/:clientId`) and client detail (`/clients/:id`) are
**root-level routes** stacked over the tab shell (see `app_router.dart`). The
in-app notifications screen opened them with `context.go(...)`, which **replaces**
the current route on the root navigator instead of stacking a new one. With
nothing to pop back to, the chat screen's back button
(`context.canPop() ? context.pop() : context.go('/chats')`) fell through to
`go('/chats')` — dropping the user on the chats tab rather than back on the
notifications list.

(The push-notification tap path in `push_service.dart` had already been switched
to `push` in an earlier change; the in-app notifications screen was the
remaining `go` site.)

## Fix

`lib/features/notifications/notifications_screen.dart` — `_onTap` now uses
`context.push(...)` for both the note/mention deep-link (`/clients/:id?noteId=`)
and the chat deep-link (`/chats/:id[?messageId=]`). Pushing stacks the detail
route over the notifications tab, so:
- back **pops** (no route replacement), and
- the pop returns to the **notifications list** (the chat screen's existing
  `canPop() ? pop() : …` back button now pops because there is a route beneath).

## Verification

- `flutter analyze` clean (changed file + full project).
- Logic: with `push`, `context.canPop()` is true in `chat_detail_screen.dart`,
  so the back button pops to the notifications screen instead of falling back to
  `go('/chats')`.

Note: this is a Flutter app — a live tap-through is verified on the iOS
simulator, not a browser. A full device repro needs a logged-in session +
notification data; the change is a minimal, analyzer-clean `go → push` swap
matching the pattern already used by the push-notification tap handler.
