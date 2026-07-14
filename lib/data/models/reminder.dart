import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder.freezed.dart';
part 'reminder.g.dart';

enum ReminderStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

enum ReminderRecurrence {
  @JsonValue('none')
  none,
  @JsonValue('daily')
  daily,
  @JsonValue('weekly')
  weekly,
  @JsonValue('monthly')
  monthly,
}

enum ReminderSource {
  @JsonValue('manual')
  manual,
  @JsonValue('auto_unanswered')
  autoUnanswered,
  @JsonValue('auto_window')
  autoWindow,
}

enum ReminderPriority {
  @JsonValue('low')
  low,
  @JsonValue('normal')
  normal,
  @JsonValue('high')
  high,
}

/// A team follow-up reminder from `GET /v1/reminders` (mobile is read/act
/// only: complete + snooze; create/edit stays on the portal).
@freezed
abstract class Reminder with _$Reminder {
  const factory Reminder({
    required String id,
    String? clientId,
    String? messageId,
    /// NULL = the shared team queue (visible in the portal; the mobile
    /// list is mine-only so queue rows normally don't appear here).
    String? assignedToUserId,
    /// NULL = created by a smart trigger.
    String? createdByUserId,
    required String title,
    String? notes,
    @JsonKey(unknownEnumValue: ReminderPriority.normal)
    @Default(ReminderPriority.normal)
    ReminderPriority priority,
    required String dueAt,
    @JsonKey(unknownEnumValue: ReminderStatus.pending)
    @Default(ReminderStatus.pending)
    ReminderStatus status,
    @JsonKey(unknownEnumValue: ReminderRecurrence.none)
    @Default(ReminderRecurrence.none)
    ReminderRecurrence recurrence,
    @JsonKey(unknownEnumValue: ReminderSource.manual)
    @Default(ReminderSource.manual)
    ReminderSource source,
    @Default(0) int snoozeCount,
  }) = _Reminder;

  const Reminder._();

  factory Reminder.fromJson(Map<String, dynamic> json) =>
      _$ReminderFromJson(json);

  DateTime get dueAtDate =>
      DateTime.tryParse(dueAt)?.toLocal() ??
      DateTime.fromMillisecondsSinceEpoch(0);

  bool get isOverdue =>
      status == ReminderStatus.pending && dueAtDate.isBefore(DateTime.now());
}

/// `GET /v1/reminders/summary` — dashboard/badge counts.
@freezed
abstract class ReminderSummary with _$ReminderSummary {
  const factory ReminderSummary({
    @Default(0) int overdue,
    @Default(0) int dueToday,
    @Default(0) int upcoming,
  }) = _ReminderSummary;

  factory ReminderSummary.fromJson(Map<String, dynamic> json) =>
      _$ReminderSummaryFromJson(json);
}
