import 'package:freezed_annotation/freezed_annotation.dart';

part 'client.freezed.dart';
part 'client.g.dart';

/// A tenant client from `GET /v1/clients`.
@freezed
abstract class Client with _$Client {
  const factory Client({
    required String id,
    required String phoneNumber,
    String? profileName,
    String? createdAt,
  }) = _Client;

  const Client._();

  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);

  /// Best display name: profile name when set, otherwise the phone number.
  String get displayName =>
      (profileName != null && profileName!.trim().isNotEmpty)
      ? profileName!
      : '+$phoneNumber';

  String get initials {
    final source = (profileName?.trim().isNotEmpty ?? false)
        ? profileName!.trim()
        : phoneNumber;
    final parts = source.split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.elementAt(1).substring(0, 1))
        .toUpperCase();
  }
}
