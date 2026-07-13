// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

enum NotificationSeverity {
  @JsonValue('info')
  info,
  @JsonValue('success')
  success,
  @JsonValue('warning')
  warning,
  @JsonValue('critical')
  critical,
}

/// An in-app notification from `GET /v1/notifications`. Title/body are stored as
/// i18n keys + params (rendered client-side via NotificationI18n).
@freezed
abstract class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    required String eventKey,
    String? category,
    @JsonKey(unknownEnumValue: NotificationSeverity.info)
    @Default(NotificationSeverity.info)
    NotificationSeverity severity,
    required String titleKey,
    @Default(<String, dynamic>{}) Map<String, dynamic> titleParams,
    required String bodyKey,
    @Default(<String, dynamic>{}) Map<String, dynamic> bodyParams,
    String? resourceType,
    String? resourceId,
    String? actionUrl,
    String? readAt,
    String? archivedAt,
    required String createdAt,
  }) = _AppNotification;

  const AppNotification._();

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);

  bool get isRead => readAt != null;

  DateTime get createdAtDate =>
      DateTime.tryParse(createdAt)?.toLocal() ??
      DateTime.fromMillisecondsSinceEpoch(0);
}
