import 'package:dio/dio.dart';

import '../models/user.dart';

class LoginResult {
  const LoginResult({
    required this.accessToken,
    required this.refreshToken,
    this.user,
  });
  final String accessToken;
  final String refreshToken;
  final User? user;
}

class AuthRepo {
  AuthRepo(this._dio);
  final Dio _dio;

  /// `POST /auth/login` — requires a reCAPTCHA Enterprise token (D6).
  ///
  /// [recaptchaPlatform] tells the API which site key to verify the token
  /// against ('android' / 'ios'); each platform registers its own key.
  Future<LoginResult> login({
    required String email,
    required String password,
    required String recaptchaToken,
    required String recaptchaPlatform,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
        'recaptchaToken': recaptchaToken,
        'recaptchaPlatform': recaptchaPlatform,
      },
    );
    final data = res.data!;
    final userJson = data['user'] as Map<String, dynamic>?;
    return LoginResult(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
      user: userJson == null ? null : User.fromJson(userJson),
    );
  }

  /// `GET /me` — full profile (locale/timezone/avatar).
  Future<User> me() async {
    final res = await _dio.get<Map<String, dynamic>>('/me');
    return User.fromJson(res.data!);
  }

  /// `PATCH /me` — partial profile update (identity + preferences). Omitted
  /// fields are left unchanged; the server rejects unknown keys. Returns the
  /// full updated profile.
  Future<User> updateMe({
    String? name,
    String? phoneNumber,
    String? locale,
    String? timezone,
    String? font,
  }) async {
    final res = await _dio.patch<Map<String, dynamic>>(
      '/me',
      data: {
        'name': ?name,
        'phoneNumber': ?phoneNumber,
        'locale': ?locale,
        'timezone': ?timezone,
        'font': ?font,
      },
    );
    return User.fromJson(res.data!);
  }

  /// `POST /me/avatar` — multipart upload (field `file`, image/*, ≤2 MB).
  /// The API stores it in S3 and returns the profile with a fresh signed
  /// `avatarUrl` (~1h expiry — treat it as ephemeral, never cache long-term).
  Future<User> uploadAvatar({
    required String filePath,
    String? filename,
  }) async {
    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: filename),
    });
    final res = await _dio.post<Map<String, dynamic>>('/me/avatar', data: form);
    return User.fromJson(res.data!);
  }

  /// `DELETE /me/avatar` — removes the stored picture; returns the profile
  /// with `avatarUrl: null`.
  Future<User> removeAvatar() async {
    final res = await _dio.delete<Map<String, dynamic>>('/me/avatar');
    return User.fromJson(res.data!);
  }

  /// `POST /me/email` — starts the email-change flow (password-confirmed).
  /// The server emails a confirmation link to [newEmail] (24h TTL) and sets
  /// `pendingEmail`; the address only changes after the link is opened.
  Future<void> requestEmailChange({
    required String newEmail,
    required String currentPassword,
  }) async {
    await _dio.post<void>(
      '/me/email',
      data: {'newEmail': newEmail, 'currentPassword': currentPassword},
    );
  }

  /// `POST /me/password` — verifies [currentPassword], sets [newPassword]
  /// (min 8 chars) and revokes every refresh session server-side, so other
  /// devices are signed out on their next token refresh.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _dio.post<void>(
      '/me/password',
      data: {'currentPassword': currentPassword, 'newPassword': newPassword},
    );
  }

  /// `POST /auth/logout` — best-effort server-side revocation. Passing this
  /// device's [refreshToken] revokes only its session; omitting it revokes
  /// every session for the user.
  Future<void> logout({String? refreshToken}) async {
    try {
      await _dio.post<void>(
        '/auth/logout',
        data: {'refreshToken': ?refreshToken},
      );
    } on DioException {
      // Logout must succeed locally even if the network call fails.
    }
  }
}
