# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Lumenta Mobile is a Flutter companion app for tenant (business) users: log in, browse clients, view WhatsApp-style chat threads with media, send replies inside the 24h service window, and read in-app notifications. Backend is a NestJS API (`/v1` prefix); contract details live in `README.md`.

## Commands

```bash
flutter pub get

# Code generation — REQUIRED after editing any @freezed model, riverpod_annotation
# provider, or json_serializable class. Generated *.g.dart / *.freezed.dart are
# committed and excluded from analysis; never hand-edit them.
dart run build_runner build --delete-conflicting-outputs
dart run build_runner watch  --delete-conflicting-outputs   # during model work

# Localizations — regenerate AppLocalizations from the ARB files (config in l10n.yaml)
flutter gen-l10n

# Run / build (dart-defines are how all env config is injected — see Env below)
flutter run \
  --dart-define=API_BASE_URL=https://<host>/v1 \
  --dart-define=RECAPTCHA_SITE_KEY=<mobile reCAPTCHA Enterprise key> \
  --dart-define=FLAVOR=dev
flutter build ios --simulator --debug      # build for the iOS simulator

flutter analyze                            # lint/static analysis (must be clean)
flutter test                               # all tests
flutter test test/widget_test.dart         # a single test file
flutter test --plain-name "substring"      # a single test by name
```

`RECAPTCHA_SITE_KEY` must be a **mobile** (Android/iOS) reCAPTCHA Enterprise key, passed per platform. Without it, real login is disabled (surfaces a "not configured" message); the rest of the app still runs.

## Architecture

State management is **Riverpod** throughout; UI is `flutter_riverpod` `ConsumerWidget`s reading `StateNotifierProvider`s. Most providers are hand-written (not generated), though `riverpod_annotation` + `riverpod_generator` are available.

**Provider/dependency graph** (`lib/core/providers.dart`) — single source of truth for the data layer wiring:
`tokenStorageProvider` → `authSessionProvider` → `dioProvider` → all `*RepoProvider`s. There is **one** `Dio` instance; every repo shares it.

**Auth + session is the spine of the app.** Three pieces work together:
- `AuthSession` (`data/session/auth_session.dart`) — a `ChangeNotifier` holding an in-memory mirror of tokens + active tenant, so the Dio interceptor can read them *synchronously*. Persistence is `flutter_secure_storage` (Keychain/Keystore). Calling `clear()` notifies listeners.
- `buildDio` interceptor (`data/http/dio_client.dart`) — injects `Authorization: Bearer` and `X-Tenant-Id` on every request, and does **single-flight token refresh** on 401 (concurrent 401s share one `/auth/refresh` call, then the original request is replayed once). Refresh failure clears the session.
- `AuthController` (`features/auth/auth_controller.dart`) — a `StateNotifier` driving a 4-state machine: `bootstrapping → unauthenticated → needsTenant → authenticated`. It listens to `AuthSession`; when the interceptor clears the session, the controller drops to `unauthenticated`.

**Routing** (`lib/core/router/app_router.dart`) — `go_router` with a `redirect` that reads `AuthStatus` and forces the matching screen (`/splash`, `/login`, `/select-tenant`, or the tab shell). `_AuthRefresh` bridges Riverpod auth-state changes into go_router's `refreshListenable`. The three tabs (clients/chats/notifications) live in a `StatefulShellRoute.indexedStack` under `HomeShell`; **chat detail (`/chats/:clientId`) is a root-level route**, not inside the shell, so it's reachable from any tab and from notification deep-links.

**Multi-tenancy** — every request carries `X-Tenant-Id`; the server enforces cross-tenant access by returning 404. The active tenant is persisted; switching tenants (`selectTenant`) re-routes via the auth state machine. A user with one tenant auto-selects it; multiple tenants → `needsTenant` → picker.

**Data layer** — `data/models` are `@freezed` + `json_serializable` (look for `*.freezed.dart` / `*.g.dart`). `data/repos` wrap Dio endpoints. Feature controllers (e.g. `clients_controller.dart`, `chats_controller.dart`, `notifications_controller.dart`, `thread_controller.dart`) are `StateNotifier`s that own list state, cursor pagination, loading/error flags, and refresh.

**Two independent i18n systems:**
1. UI strings → Flutter `gen-l10n` from `lib/core/i18n/arb/app_{en,ar,fr}.arb` into `AppLocalizations`. Arabic drives RTL. `localeProvider` hydrates the locale from the logged-in user's profile (null = follow system).
2. Notification strings → `core/i18n/notification_i18n.dart` loads JSON bundles from `assets/i18n/notifications/` at startup (`NotificationI18n.load()` in `main()`). Server sends **i18n keys** (`titleKey`/`bodyKey` + params), rendered client-side — mirrors the web portal's `notifications` namespace.

**Authenticated media** — `GET /messages/:id/media` requires the Bearer header, which streamed URLs can't carry. So images use `CachedNetworkImage` with `httpHeaders` (`mediaHeadersProvider`), and audio (`widgets/audio_bubble.dart`) downloads bytes via Dio and plays them from memory.

**Unread tracking** — chat unread is an **on-device last-read cursor** (`data/storage/last_read_store.dart`, hydrated in `main()`); there is no server read-state for chats. Notifications *do* have server read-state (`PATCH /:id/read`, `mark-all-read`).

**Push (FCM)** — `features/push/push_service.dart` owns the full lifecycle (permission, register on login via `DeviceRepo`, re-register on token refresh, deregister + `deleteToken()` on logout, foreground local notifications, tap → deep-link to `/chats/:clientId` switching tenant if needed). It **degrades gracefully**: with no native Firebase config the app runs normally and only push is disabled. Enabling push needs `google-services.json` (Android) / `GoogleService-Info.plist` (iOS) + APNs key — see README.

**Startup order** (`lib/main.dart`) — load notification bundles → hydrate last-read store → kick off (non-awaited) auth `bootstrap()` (splash shows until it resolves) → `runApp` → init push. App is hosted in an `UncontrolledProviderScope` around a manually-created `ProviderContainer`.

## Design system

UI work should reuse the theme/token layer rather than hardcoding values:
- `core/theme/app_dimens.dart` — `Insets`, `Radii`, `Motion`, `Shadows` tokens (no magic spacing/radius numbers).
- `core/theme/app_colors.dart` — the brand palette + derived tones; add new tones here, don't inline hex.
- `core/theme/app_theme.dart` — one `_build(brightness)` produces light + dark with full component themes and two `ThemeExtension`s (`ChatColors`, `BrandColors`). Access via the `ThemeX` extension on `BuildContext`: `context.scheme`, `context.text`, `context.brand`, `context.chat`.
- `features/shared/` — reusable `brand_mark.dart` (`AppIconMark`, `LumentaMark`, `LumentaWordmark`), `skeletons.dart` (`Shimmer`/`SkeletonList` for first-load), and `widgets.dart` (`InitialsAvatar`, `EmptyState`, `ErrorRetry`, `StatusPill`).

## Conventions & gotchas

- **`permission_handler` is intentionally absent** — `FirebaseMessaging` and `image_picker` request their own permissions. Adding it compiles all permission pods (incl. CoreLocation), triggering App Store rejection ITMS-90683. Don't add it. (See the note in `pubspec.yaml`.)
- App bundle id is `com.codemina.apps.lumenta` (Android + iOS).
- `Env` (`core/config/env.dart`) is the only config surface — all values come from `--dart-define` (`API_BASE_URL`, `RECAPTCHA_SITE_KEY`, `FLAVOR`). No `.env` file.
- Keep changes to controllers/providers/routing separate from pure presentation work; the widget layer should not embed business logic.
