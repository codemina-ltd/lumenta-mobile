// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

import 'inbox_label.dart';

part 'inbox_thread.freezed.dart';
part 'inbox_thread.g.dart';

/// Contact summary embedded on a thread (the operator's "who is this").
@freezed
class InboxThreadContact with _$InboxThreadContact {
  const factory InboxThreadContact({
    required String id,
    required String phoneNumber,
    String? profileName,
  }) = _InboxThreadContact;

  factory InboxThreadContact.fromJson(Map<String, dynamic> json) =>
      _$InboxThreadContactFromJson(json);
}

/// A Team Inbox support thread keyed by (tenant, sender, client)
/// (LUMENTA_GROWTH plan §1.1). The mobile app is the operate-on-the-go
/// surface (§14): read, assign, change status, label, note.
@freezed
class InboxThread with _$InboxThread {
  const factory InboxThread({
    required String id,
    required String senderId,
    required String clientId,
    @Default('open') String status,
    String? assignedUserId,
    @Default('normal') String priority,
    String? snoozedUntil,
    String? lastInboundAt,
    String? lastOutboundAt,
    @Default(0) int unreadCount,
    String? serviceWindowExpiresAt,
    String? updatedAt,
    @Default(<InboxLabel>[]) List<InboxLabel> labels,
    InboxThreadContact? client,
  }) = _InboxThread;

  const InboxThread._();

  factory InboxThread.fromJson(Map<String, dynamic> json) =>
      _$InboxThreadFromJson(json);

  String get displayName {
    final name = client?.profileName;
    if (name != null && name.trim().isNotEmpty) return name;
    final phone = client?.phoneNumber;
    return phone != null ? '+$phone' : 'Unknown contact';
  }

  DateTime? get updatedAtDate =>
      updatedAt == null ? null : DateTime.tryParse(updatedAt!)?.toLocal();
}
