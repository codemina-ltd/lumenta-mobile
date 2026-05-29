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
  Future<LoginResult> login({
    required String email,
    required String password,
    required String recaptchaToken,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
        'recaptchaToken': recaptchaToken,
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

  /// `POST /auth/logout` — best-effort server-side revocation.
  Future<void> logout() async {
    try {
      await _dio.post<void>('/auth/logout');
    } on DioException {
      // Logout must succeed locally even if the network call fails.
    }
  }
}
