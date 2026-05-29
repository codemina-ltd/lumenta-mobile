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
| 6 | Firebase / FCM push | ⏳ deferred |
| 7 | Reply composer (24h window) | ⏳ optional |
| 8 | Hardening / release | ⏳ |

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

## Notes

- Unread badges use an on-device last-read cursor (D7) — no server read state.
- Notification title/body are i18n keys rendered client-side
  (`core/i18n/notification_i18n.dart`), mirroring the portal's `notifications`
  namespace.
- Firebase is a dependency but not initialized yet (Phase 6 adds
  `google-services.json` / `GoogleService-Info.plist`, APNs key, and init).
