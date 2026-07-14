// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Reminder _$ReminderFromJson(Map<String, dynamic> json) => _Reminder(
  id: json['id'] as String,
  clientId: json['clientId'] as String?,
  messageId: json['messageId'] as String?,
  assignedToUserId: json['assignedToUserId'] as String,
  createdByUserId: json['createdByUserId'] as String,
  title: json['title'] as String,
  notes: json['notes'] as String?,
  priority:
      $enumDecodeNullable(
        _$ReminderPriorityEnumMap,
        json['priority'],
        unknownValue: ReminderPriority.normal,
      ) ??
      ReminderPriority.normal,
  dueAt: json['dueAt'] as String,
  status:
      $enumDecodeNullable(
        _$ReminderStatusEnumMap,
        json['status'],
        unknownValue: ReminderStatus.pending,
      ) ??
      ReminderStatus.pending,
  snoozeCount: (json['snoozeCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ReminderToJson(_Reminder instance) => <String, dynamic>{
  'id': instance.id,
  'clientId': instance.clientId,
  'messageId': instance.messageId,
  'assignedToUserId': instance.assignedToUserId,
  'createdByUserId': instance.createdByUserId,
  'title': instance.title,
  'notes': instance.notes,
  'priority': _$ReminderPriorityEnumMap[instance.priority]!,
  'dueAt': instance.dueAt,
  'status': _$ReminderStatusEnumMap[instance.status]!,
  'snoozeCount': instance.snoozeCount,
};

const _$ReminderPriorityEnumMap = {
  ReminderPriority.low: 'low',
  ReminderPriority.normal: 'normal',
  ReminderPriority.high: 'high',
};

const _$ReminderStatusEnumMap = {
  ReminderStatus.pending: 'pending',
  ReminderStatus.completed: 'completed',
  ReminderStatus.cancelled: 'cancelled',
};

_ReminderSummary _$ReminderSummaryFromJson(Map<String, dynamic> json) =>
    _ReminderSummary(
      overdue: (json['overdue'] as num?)?.toInt() ?? 0,
      dueToday: (json['dueToday'] as num?)?.toInt() ?? 0,
      upcoming: (json['upcoming'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ReminderSummaryToJson(_ReminderSummary instance) =>
    <String, dynamic>{
      'overdue': instance.overdue,
      'dueToday': instance.dueToday,
      'upcoming': instance.upcoming,
    };
