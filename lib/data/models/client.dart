// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'client.freezed.dart';
part 'client.g.dart';

/// A tenant client from `GET /v1/clients`.
@freezed
abstract class Client with _$Client {
  const factory Client({
    required String id,

    /// Null for channel-only contacts (Instagram/Messenger) that have no
    /// WhatsApp phone number.
    String? phoneNumber,

    /// Channel-owned WhatsApp profile name (what the customer typed into
    /// WhatsApp). Never edited by a workspace (KAN-301).
    String? profileName,

    /// KAN-301 — this workspace's own name for the client
    /// (`contact_profiles.display_name`); null when not set. The JSON key is
    /// `displayName`, kept apart from the [displayName] getter below.
    @JsonKey(name: 'displayName') String? workspaceName,

    /// KAN-301 — effective name from the API: [workspaceName], else
    /// [profileName]. Null on servers predating the field.
    String? name,
    String? createdAt,
  }) = _Client;

  const Client._();

  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);

  /// Effective name (KAN-301): the workspace's own name, else the WhatsApp
  /// profile name, else null.
  String? get effectiveName =>
      _nonBlank(name) ?? _nonBlank(workspaceName) ?? _nonBlank(profileName);

  /// True when this workspace renamed the client and the WhatsApp profile
  /// name is a different, non-empty value worth showing as a secondary line.
  bool get hasDistinctWhatsAppName {
    final ws = _nonBlank(workspaceName);
    final wa = _nonBlank(profileName);
    return ws != null && wa != null && ws != wa;
  }

  /// Best display name: effective name when set, otherwise the phone number,
  /// otherwise a neutral fallback (mirrors InboxThread.displayName).
  String get displayName {
    final effective = effectiveName;
    if (effective != null) return effective;
    final phone = phoneNumber;
    return phone != null ? '+$phone' : 'Unknown contact';
  }

  String get initials {
    final source = effectiveName ?? (phoneNumber ?? '');
    // Skip symbol-only words (the dash in "Ahmed — VIP") so initials come
    // from real name parts.
    final parts = source
        .split(RegExp(r'\s+'))
        .where((p) => RegExp(r'[\p{L}\p{N}]', unicode: true).hasMatch(p));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.elementAt(1).substring(0, 1))
        .toUpperCase();
  }

  static String? _nonBlank(String? v) {
    final t = v?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }
}
