import 'package:dio/dio.dart';

import '../models/contact_field.dart';
import '../models/contact_profile.dart';

/// Contact CRM API client (LUMENTA_GROWTH plan §2). The mobile app reads and
/// quick-edits a contact's lifecycle, opt-in, and custom fields (§14).
class ContactsRepo {
  ContactsRepo(this._dio);
  final Dio _dio;

  Future<ContactProfileResponse> profile(String clientId) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/contacts/$clientId/profile',
    );
    return ContactProfileResponse.fromJson(res.data!);
  }

  Future<List<ContactLifecycleStage>> lifecycleStages() async {
    final res = await _dio.get<List<dynamic>>('/contacts/lifecycle-stages');
    return (res.data ?? const [])
        .map((e) => ContactLifecycleStage.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ContactField>> fields() async {
    final res = await _dio.get<List<dynamic>>('/contacts/fields');
    return (res.data ?? const [])
        .map((e) => ContactField.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ContactProfile> updateProfile(
    String clientId, {
    Object? lifecycleStageId = _unset,
    bool? optInMarketing,
    String? displayName,
    String? locale,
  }) async {
    final body = <String, dynamic>{
      if (!identical(lifecycleStageId, _unset))
        'lifecycleStageId': lifecycleStageId,
      'optInMarketing': ?optInMarketing,
      'displayName': ?displayName,
      'locale': ?locale,
    };
    final res = await _dio.patch<Map<String, dynamic>>(
      '/contacts/$clientId/profile',
      data: body,
    );
    return ContactProfile.fromJson(res.data!);
  }

  Future<void> setFieldValue(
    String clientId,
    String key,
    Object? value,
  ) async {
    await _dio.put<void>(
      '/contacts/$clientId/fields',
      data: {'key': key, 'value': value},
    );
  }

  /// `GET /attribution/ctwa/:clientId` — Click-to-WhatsApp referrals, newest
  /// first (LUMENTA_GROWTH plan §4.3). Read-only "Came from" on mobile.
  Future<List<CtwaReferral>> ctwa(String clientId) async {
    final res = await _dio.get<List<dynamic>>('/attribution/ctwa/$clientId');
    return (res.data ?? const [])
        .map((e) => CtwaReferral.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

/// Lightweight read model for a CTWA referral (no codegen needed).
class CtwaReferral {
  const CtwaReferral({this.headline, this.sourceType});
  final String? headline;
  final String? sourceType;

  factory CtwaReferral.fromJson(Map<String, dynamic> m) => CtwaReferral(
    headline: m['headline'] as String?,
    sourceType: m['sourceType'] as String?,
  );

  String get label => (headline?.trim().isNotEmpty ?? false)
      ? headline!
      : (sourceType ?? 'an ad');
}

/// Sentinel so `updateProfile` can distinguish "leave unchanged" from
/// "explicitly clear to null" on the nullable lifecycle field.
const Object _unset = Object();
