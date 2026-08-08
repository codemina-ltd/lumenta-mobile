// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'client_phone_number.freezed.dart';
part 'client_phone_number.g.dart';

/// One WhatsApp number a unified client profile can be reached on
/// (KAN-28), from `GET /v1/clients/:id/phone-numbers`. The single
/// `isPrimary` row mirrors the client's canonical number; the rest are
/// numbers folded on by merging two WhatsApp contacts into one profile.
@freezed
abstract class ClientPhoneNumber with _$ClientPhoneNumber {
  const factory ClientPhoneNumber({
    required String id,
    required String clientId,
    required String phoneNumber,
    @Default(false) bool isPrimary,
    String? label,
    String? createdAt,
  }) = _ClientPhoneNumber;

  const ClientPhoneNumber._();

  factory ClientPhoneNumber.fromJson(Map<String, dynamic> json) =>
      _$ClientPhoneNumberFromJson(json);
}
