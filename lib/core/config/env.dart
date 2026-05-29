/// Build-time configuration, injected via `--dart-define`.
///
/// Example:
/// ```
/// flutter run \
///   --dart-define=API_BASE_URL=https://staging.api.lumenta.co/v1 \
///   --dart-define=RECAPTCHA_SITE_KEY=6Lxxxxxxxxxxxxxxxxxxxx \
///   --dart-define=FLAVOR=dev
/// ```
class Env {
  const Env._();

  /// Base URL of the NestJS API, including the `/v1` version prefix.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/v1',
  );

  /// reCAPTCHA Enterprise **mobile** site key (Android/iOS), used to mint the
  /// `recaptchaToken` the API requires on `/auth/login` and `/auth/register`.
  static const String recaptchaSiteKey = String.fromEnvironment(
    'RECAPTCHA_SITE_KEY',
  );

  /// Build flavor: `dev` or `prod`.
  static const String flavor = String.fromEnvironment(
    'FLAVOR',
    defaultValue: 'dev',
  );

  static bool get isProd => flavor == 'prod';

  /// Whether a reCAPTCHA site key was supplied. When false, login falls back to
  /// a stub token (dev only) so the app remains runnable without the key.
  static bool get hasRecaptchaKey => recaptchaSiteKey.isNotEmpty;
}
