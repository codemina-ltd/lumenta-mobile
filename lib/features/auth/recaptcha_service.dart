import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_action.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_client.dart';

import '../../core/config/env.dart';

/// Mints reCAPTCHA Enterprise tokens for the actions the API verifies
/// (`LOGIN`, `SIGNUP`). The mobile site key is supplied via [Env.recaptchaSiteKey].
///
/// When no key is configured (dev), [RecaptchaUnavailable] is thrown so the UI
/// can explain login is not set up rather than silently failing server-side.
class RecaptchaService {
  RecaptchaClient? _client;
  bool _initStarted = false;

  Future<RecaptchaClient> _ensureClient() async {
    if (_client != null) return _client!;
    if (!Env.hasRecaptchaKey) {
      throw const RecaptchaUnavailable();
    }
    _initStarted = true;
    _client = await Recaptcha.fetchClient(Env.recaptchaSiteKey);
    return _client!;
  }

  /// Execute for the `LOGIN` action and return the token.
  ///
  /// The backend compares the token's action verbatim and expects the
  /// uppercase `'LOGIN'` the web portal sends, so we use a custom action
  /// rather than the SDK's `LOGIN()` (which emits lowercase `"login"`).
  Future<String> tokenForLogin() =>
      _execute(RecaptchaAction.custom('LOGIN'));

  Future<String> _execute(RecaptchaAction action) async {
    try {
      final client = await _ensureClient();
      return await client.execute(action);
    } on RecaptchaUnavailable {
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('reCAPTCHA execute failed: $e');
      }
      rethrow;
    }
  }

  bool get isConfigured => Env.hasRecaptchaKey;
  bool get initialized => _initStarted;
}

/// Thrown when login is attempted without a configured reCAPTCHA mobile key.
class RecaptchaUnavailable implements Exception {
  const RecaptchaUnavailable();
  @override
  String toString() => 'reCAPTCHA is not configured (missing site key).';
}

final recaptchaServiceProvider = Provider<RecaptchaService>(
  (ref) => RecaptchaService(),
);
