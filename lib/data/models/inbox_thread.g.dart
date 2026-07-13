// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbox_thread.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InboxThreadContact _$InboxThreadContactFromJson(Map<String, dynamic> json) =>
    _InboxThreadContact(
      id: json['id'] as String,
      phoneNumber: json['phoneNumber'] as String,
      profileName: json['profileName'] as String?,
    );

Map<String, dynamic> _$InboxThreadContactToJson(_InboxThreadContact instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phoneNumber': instance.phoneNumber,
      'profileName': instance.profileName,
    };

_InboxThread _$InboxThreadFromJson(Map<String, dynamic> json) => _InboxThread(
  id: json['id'] as String,
  senderId: json['senderId'] as String,
  clientId: json['clientId'] as String,
  status: json['status'] as String? ?? 'open',
  assignedUserId: json['assignedUserId'] as String?,
  priority: json['priority'] as String? ?? 'normal',
  snoozedUntil: json['snoozedUntil'] as String?,
  lastInboundAt: json['lastInboundAt'] as String?,
  lastOutboundAt: json['lastOutboundAt'] as String?,
  unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
  serviceWindowExpiresAt: json['serviceWindowExpiresAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  labels:
      (json['labels'] as List<dynamic>?)
          ?.map((e) => InboxLabel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <InboxLabel>[],
  client: json['client'] == null
      ? null
      : InboxThreadContact.fromJson(json['client'] as Map<String, dynamic>),
);

Map<String, dynamic> _$InboxThreadToJson(_InboxThread instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'clientId': instance.clientId,
      'status': instance.status,
      'assignedUserId': instance.assignedUserId,
      'priority': instance.priority,
      'snoozedUntil': instance.snoozedUntil,
      'lastInboundAt': instance.lastInboundAt,
      'lastOutboundAt': instance.lastOutboundAt,
      'unreadCount': instance.unreadCount,
      'serviceWindowExpiresAt': instance.serviceWindowExpiresAt,
      'updatedAt': instance.updatedAt,
      'labels': instance.labels,
      'client': instance.client,
    };
