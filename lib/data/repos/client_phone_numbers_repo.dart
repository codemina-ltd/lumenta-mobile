import 'package:dio/dio.dart';

import '../models/client_phone_number.dart';

/// Phone numbers on a unified client profile (KAN-28) + the contact-merge
/// action that folds two WhatsApp contacts into one profile.
class ClientPhoneNumbersRepo {
  ClientPhoneNumbersRepo(this._dio);
  final Dio _dio;

  /// `GET /clients/:id/phone-numbers` — primary first, then additional.
  Future<List<ClientPhoneNumber>> list(String clientId) async {
    final res = await _dio.get<List<dynamic>>(
      '/clients/$clientId/phone-numbers',
    );
    return (res.data ?? [])
        .map((e) => ClientPhoneNumber.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// `POST /clients/:id/phone-numbers` — attach an additional number.
  Future<ClientPhoneNumber> add({
    required String clientId,
    required String phoneNumber,
    String? label,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/clients/$clientId/phone-numbers',
      data: {'phoneNumber': phoneNumber, 'label': ?label},
    );
    return ClientPhoneNumber.fromJson(res.data!);
  }

  /// `PATCH /clients/:id/phone-numbers/:phoneNumberId/primary` — promote a
  /// number to the profile's canonical number.
  Future<List<ClientPhoneNumber>> setPrimary({
    required String clientId,
    required String phoneNumberId,
  }) async {
    final res = await _dio.patch<List<dynamic>>(
      '/clients/$clientId/phone-numbers/$phoneNumberId/primary',
    );
    return (res.data ?? [])
        .map((e) => ClientPhoneNumber.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// `DELETE /clients/:id/phone-numbers/:phoneNumberId` — detach an
  /// additional number (the primary cannot be removed).
  Future<void> remove({
    required String clientId,
    required String phoneNumberId,
  }) async {
    await _dio.delete<void>(
      '/clients/$clientId/phone-numbers/$phoneNumberId',
    );
  }

  /// `POST /clients/:winnerId/merge` — merge [loserClientId] into
  /// [winnerClientId]; the loser's numbers fold on as additional numbers.
  Future<void> merge({
    required String winnerClientId,
    required String loserClientId,
  }) async {
    await _dio.post<Map<String, dynamic>>(
      '/clients/$winnerClientId/merge',
      data: {'loserClientId': loserClientId},
    );
  }
}
