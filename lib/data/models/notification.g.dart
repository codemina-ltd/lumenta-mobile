// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppNotificationImpl _$$AppNotificationImplFromJson(
  Map<String, dynamic> json,
) => _$AppNotificationImpl(
  id: json['id'] as String,
  eventKey: json['eventKey'] as String,
  category: json['category'] as String?,
  severity:
      $enumDecodeNullable(
        _$NotificationSeverityEnumMap,
        json['severity'],
        unknownValue: NotificationSeverity.info,
      ) ??
      NotificationSeverity.info,
  titleKey: json['titleKey'] as String,
  titleParams:
      json['titleParams'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  bodyKey: json['bodyKey'] as String,
  bodyParams:
      json['bodyParams'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  resourceType: json['resourceType'] as String?,
  resourceId: json['resourceId'] as String?,
  actionUrl: json['actionUrl'] as String?,
  readAt: json['readAt'] as String?,
  archivedAt: json['archivedAt'] as String?,
  createdAt: json['createdAt'] as String,
);

Map<String, dynamic> _$$AppNotificationImplToJson(
  _$AppNotificationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'eventKey': instance.eventKey,
  'category': instance.category,
  'severity': _$NotificationSeverityEnumMap[instance.severity]!,
  'titleKey': instance.titleKey,
  'titleParams': instance.titleParams,
  'bodyKey': instance.bodyKey,
  'bodyParams': instance.bodyParams,
  'resourceType': instance.resourceType,
  'resourceId': instance.resourceId,
  'actionUrl': instance.actionUrl,
  'readAt': instance.readAt,
  'archivedAt': instance.archivedAt,
  'createdAt': instance.createdAt,
};

const _$NotificationSeverityEnumMap = {
  NotificationSeverity.info: 'info',
  NotificationSeverity.success: 'success',
  NotificationSeverity.warning: 'warning',
  NotificationSeverity.critical: 'critical',
};
