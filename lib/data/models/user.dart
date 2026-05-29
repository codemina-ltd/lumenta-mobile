import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// Current user profile from `GET /v1/me`.
@freezed
class User with _$User {
  const factory User({
    required String id,
    String? email,
    String? name,
    String? phoneNumber,
    String? profileName,
    String? locale,
    String? timezone,
    String? font,
    String? avatarUrl,
    String? pendingEmail,
    String? createdAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
