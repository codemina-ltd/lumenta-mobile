// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_profile.freezed.dart';
part 'contact_profile.g.dart';

/// Per-(tenant, client) CRM profile (LUMENTA_GROWTH plan §2.1). Mobile shows
/// lifecycle + opt-in read + quick-edit (§14).
@freezed
class ContactProfile with _$ContactProfile {
  const factory ContactProfile({
    required String id,
    required String clientId,
    String? lifecycleStageId,
    String? source,
    String? displayName,
    String? locale,
    @Default(false) bool optInMarketing,
    String? optInAt,
    String? firstContactedAt,
    String? lastContactedAt,
  }) = _ContactProfile;

  factory ContactProfile.fromJson(Map<String, dynamic> json) =>
      _$ContactProfileFromJson(json);
}

/// `GET /contacts/:clientId/profile` envelope.
@freezed
class ContactProfileResponse with _$ContactProfileResponse {
  const factory ContactProfileResponse({
    ContactProfile? profile,
    @Default(<String, String>{}) Map<String, String> fieldValues,
  }) = _ContactProfileResponse;

  factory ContactProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ContactProfileResponseFromJson(json);
}
