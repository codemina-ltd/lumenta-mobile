// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScheduledMessage _$ScheduledMessageFromJson(Map<String, dynamic> json) =>
    _ScheduledMessage(
      id: json['id'] as String,
      tenantId: json['tenantId'] as String,
      clientId: json['clientId'] as String,
      senderId: json['senderId'] as String?,
      createdByUserId: json['createdByUserId'] as String?,
      templateId: json['templateId'] as String?,
      templateName: json['templateName'] as String,
      templateLanguage: json['templateLanguage'] as String? ?? 'en',
      templateVariables: json['templateVariables'] as Map<String, dynamic>?,
      buttonVariables: (json['buttonVariables'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      renderedBody: json['renderedBody'] as String?,
      scheduledFor: DateTime.parse(json['scheduledFor'] as String),
      timezone: json['timezone'] as String?,
      status:
          $enumDecodeNullable(
            _$ScheduledMessageStatusEnumMap,
            json['status'],
            unknownValue: ScheduledMessageStatus.pending,
          ) ??
          ScheduledMessageStatus.pending,
      jobId: json['jobId'] as String?,
      sentMessageId: json['sentMessageId'] as String?,
      sentAt: json['sentAt'] as String?,
      cancelledByUserId: json['cancelledByUserId'] as String?,
      cancelledAt: json['cancelledAt'] as String?,
      cancellationReason: json['cancellationReason'] as String?,
      errorMessage: json['errorMessage'] as String?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$ScheduledMessageToJson(_ScheduledMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenantId': instance.tenantId,
      'clientId': instance.clientId,
      'senderId': instance.senderId,
      'createdByUserId': instance.createdByUserId,
      'templateId': instance.templateId,
      'templateName': instance.templateName,
      'templateLanguage': instance.templateLanguage,
      'templateVariables': instance.templateVariables,
      'buttonVariables': instance.buttonVariables,
      'renderedBody': instance.renderedBody,
      'scheduledFor': instance.scheduledFor.toIso8601String(),
      'timezone': instance.timezone,
      'status': _$ScheduledMessageStatusEnumMap[instance.status]!,
      'jobId': instance.jobId,
      'sentMessageId': instance.sentMessageId,
      'sentAt': instance.sentAt,
      'cancelledByUserId': instance.cancelledByUserId,
      'cancelledAt': instance.cancelledAt,
      'cancellationReason': instance.cancellationReason,
      'errorMessage': instance.errorMessage,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

const _$ScheduledMessageStatusEnumMap = {
  ScheduledMessageStatus.pending: 'pending',
  ScheduledMessageStatus.sent: 'sent',
  ScheduledMessageStatus.cancelled: 'cancelled',
  ScheduledMessageStatus.failed: 'failed',
};

_ScheduledMessageEvent _$ScheduledMessageEventFromJson(
  Map<String, dynamic> json,
) => _ScheduledMessageEvent(
  id: json['id'] as String,
  scheduledMessageId: json['scheduledMessageId'] as String,
  tenantId: json['tenantId'] as String,
  eventType: $enumDecode(
    _$ScheduledMessageEventTypeEnumMap,
    json['eventType'],
    unknownValue: ScheduledMessageEventType.scheduled,
  ),
  actorUserId: json['actorUserId'] as String?,
  actorKind: json['actorKind'] as String? ?? 'user',
  metadata: json['metadata'] as Map<String, dynamic>?,
  createdAt: json['createdAt'] as String,
);

Map<String, dynamic> _$ScheduledMessageEventToJson(
  _ScheduledMessageEvent instance,
) => <String, dynamic>{
  'id': instance.id,
  'scheduledMessageId': instance.scheduledMessageId,
  'tenantId': instance.tenantId,
  'eventType': _$ScheduledMessageEventTypeEnumMap[instance.eventType]!,
  'actorUserId': instance.actorUserId,
  'actorKind': instance.actorKind,
  'metadata': instance.metadata,
  'createdAt': instance.createdAt,
};

const _$ScheduledMessageEventTypeEnumMap = {
  ScheduledMessageEventType.scheduled: 'scheduled',
  ScheduledMessageEventType.edited: 'edited',
  ScheduledMessageEventType.cancelled: 'cancelled',
  ScheduledMessageEventType.sent: 'sent',
  ScheduledMessageEventType.failed: 'failed',
};
