# Lumenta Mobile

Flutter companion app for tenant users: log in, browse clients, view chats
(WhatsApp-style threads with media), and read in-app notifications. Built to the
plan in `../.claude/LUMENTA_MOBILE_APP_IMPLEMENTATION_PLAN.md`.

## Status (Phase 1 foundation)

Implemented: project setup, brand theme, i18n (en/ar/fr + RTL), data layer
(models + Dio + repos), auth & tenant context, and the four screens
(clients, chats, chat detail, notifications).

| Phase | Area | State |
|-------|------|-------|
| 0 | Deps, env config, app id (`co.lumenta.app`) | ✅ |
| 2 | Theme + i18n (en/ar/fr, Arabic RTL) | ✅ |
| 3 | Auth, token refresh, tenant switcher | ✅ |
| 4 | Models / Dio / repos | ✅ |
| 5 | Clients, Chats, Chat detail (media), Notifications | ✅ |
| 6 | Firebase / FCM push | ✅ (needs Firebase config files) |
| 7 | Reply composer (24h window) | ✅ text + image + document |
| 8 | Hardening / release | ✅ code-level (signing/store need accounts) |

## Run

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # freezed/json codegen

flutter run \
  --dart-define=API_BASE_URL=https://<staging-host>/v1 \
  --dart-define=RECAPTCHA_SITE_KEY=<mobile reCAPTCHA Enterprise site key> \
  --dart-define=FLAVOR=dev
```

`RECAPTCHA_SITE_KEY` must be a **mobile** reCAPTCHA Enterprise key (Android/iOS
apps registered in the Google Cloud reCAPTCHA console). The API verifies the
login token with action **`LOGIN`** (uppercase), which the client sends to match
the web portal. Without a key, login surfaces a "not configured" message.

## API contract (verified against `api/` + `portal/`)

- Tenant context: `X-Tenant-Id` header on every request.
- `POST /auth/login {email,password,recaptchaToken}` → `{user, accessToken, refreshToken}`
- `POST /auth/refresh {refreshToken}` → `{accessToken, refreshToken}` (single-flight)
- `GET /me` (full profile), `GET /tenants` (`{data:[...]}`)
- `GET /clients`, `GET /clients/:id`, `GET /clients/:id/messages`
- Media via authenticated proxy: `GET /messages/:id/media`
- `GET /notifications` (cursor), `/unread-count`, `PATCH /:id/read`, `POST /mark-all-read`
- FCM: `POST /notifications/channels/fcm/register`, `DELETE /notifications/channels/fcm`

## Backend track — done

- **`GET /messages/conversations`** — implemented (tenant-scoped, paginated,
  last message per client). The Chats tab works against it; its 404 fallback
  remains as a safety net.
- **FCM fan-out** to all tenant members on inbound message — already wired
  (`message.received` → `ALL_MEMBERS`); FCM rides along automatically for any
  registered device (opt-out, no preference seeding needed).
- **FCM `data` routing block** (type, tenant_id, client_id, action_url, …) +
  Android `messages` channel / iOS mutable-content — added to the FCM adapter.
- FCM device register/deregister endpoints already existed (upsert + auto-verify).

Server needs `FIREBASE_PROJECT_ID` + `FIREBASE_SERVICE_ACCOUNT_JSON_BASE64` for
push to actually send.

## Firebase / FCM (Phase 6)

The push lifecycle is fully wired (`lib/features/push/push_service.dart`):
permission prompt, token registration via `DeviceRepo` on login, re-register on
token refresh, deregister + `deleteToken()` on logout, foreground local
notifications, background/terminated handling, and tap → deep-link to
`/chats/:clientId` (switching tenant when the push targets another workspace).

It **degrades gracefully**: without native Firebase config the app runs and the
in-app notifications feed still works — only push is disabled.

To enable push you must provision Firebase (needs a Firebase project):

1. **Android**: add the Firebase Android app for `co.lumenta.app`, download
   `google-services.json` into `android/app/`. The Google Services Gradle
   plugin auto-applies once that file exists (already declared in
   `settings.gradle.kts` + `app/build.gradle.kts`). The `messages`
   notification channel and `POST_NOTIFICATIONS` permission are already set up.
2. **iOS**: add the Firebase iOS app for `co.lumenta.app`, download
   `GoogleService-Info.plist` into `ios/Runner/` (add it to the Runner target
   in Xcode). In Xcode → Signing & Capabilities add **Push Notifications** and
   **Background Modes → Remote notifications** (the Info.plist background mode
   is already declared). Upload an **APNs auth key** to the Firebase project.
3. Backend: set `FIREBASE_PROJECT_ID` + `FIREBASE_SERVICE_ACCOUNT_JSON_BASE64`.

`Firebase.initializeApp()` is called with no options and reads those native
config files — no `firebase_options.dart` is required.

## Hardening & release (Phase 8)

Code-level security in place: JWTs only in Keychain/Keystore (never logged),
single-flight refresh that clears the session on failure, `X-Tenant-Id` sent on
every request (server enforces cross-tenant 404), logout deregisters the FCM
device server-side and calls `deleteToken()`. Android desugaring + `minSdk 23`.

Still required for store release (need accounts/keys):

- **Android**: release signing keystore + `signingConfigs`; Play Console
  listing; staged rollout. (R8/ProGuard defaults work for the current plugins.)
- **iOS**: Apple Developer account, distribution signing, App Store privacy
  labels.
- **Optional**: `sentry_flutter` (needs a DSN) for crash reporting — strip PII /
  tokens from breadcrumbs; certificate pinning on the Dio client.
- **QA matrix**: foreground/background/terminated push × Android 13+/iOS ×
  en/ar(RTL)/fr × single/multi-tenant.

## Notes

- Unread badges use an on-device last-read cursor (D7) — no server read state.
- Notification title/body are i18n keys rendered client-side
  (`core/i18n/notification_i18n.dart`), mirroring the portal's `notifications`
  namespace.
- Firebase is a dependency but not initialized yet (Phase 6 adds
  `google-services.json` / `GoogleService-Info.plist`, APNs key, and init).
