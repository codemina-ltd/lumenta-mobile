// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) {
  return _AppNotification.fromJson(json);
}

/// @nodoc
mixin _$AppNotification {
  String get id => throw _privateConstructorUsedError;
  String get eventKey => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: NotificationSeverity.info)
  NotificationSeverity get severity => throw _privateConstructorUsedError;
  String get titleKey => throw _privateConstructorUsedError;
  Map<String, dynamic> get titleParams => throw _privateConstructorUsedError;
  String get bodyKey => throw _privateConstructorUsedError;
  Map<String, dynamic> get bodyParams => throw _privateConstructorUsedError;
  String? get resourceType => throw _privateConstructorUsedError;
  String? get resourceId => throw _privateConstructorUsedError;
  String? get actionUrl => throw _privateConstructorUsedError;
  String? get readAt => throw _privateConstructorUsedError;
  String? get archivedAt => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;

  /// Serializes this AppNotification to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppNotification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppNotificationCopyWith<AppNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppNotificationCopyWith<$Res> {
  factory $AppNotificationCopyWith(
    AppNotification value,
    $Res Function(AppNotification) then,
  ) = _$AppNotificationCopyWithImpl<$Res, AppNotification>;
  @useResult
  $Res call({
    String id,
    String eventKey,
    String? category,
    @JsonKey(unknownEnumValue: NotificationSeverity.info)
    NotificationSeverity severity,
    String titleKey,
    Map<String, dynamic> titleParams,
    String bodyKey,
    Map<String, dynamic> bodyParams,
    String? resourceType,
    String? resourceId,
    String? actionUrl,
    String? readAt,
    String? archivedAt,
    String createdAt,
  });
}

/// @nodoc
class _$AppNotificationCopyWithImpl<$Res, $Val extends AppNotification>
    implements $AppNotificationCopyWith<$Res> {
  _$AppNotificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppNotification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventKey = null,
    Object? category = freezed,
    Object? severity = null,
    Object? titleKey = null,
    Object? titleParams = null,
    Object? bodyKey = null,
    Object? bodyParams = null,
    Object? resourceType = freezed,
    Object? resourceId = freezed,
    Object? actionUrl = freezed,
    Object? readAt = freezed,
    Object? archivedAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            eventKey: null == eventKey
                ? _value.eventKey
                : eventKey // ignore: cast_nullable_to_non_nullable
                      as String,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            severity: null == severity
                ? _value.severity
                : severity // ignore: cast_nullable_to_non_nullable
                      as NotificationSeverity,
            titleKey: null == titleKey
                ? _value.titleKey
                : titleKey // ignore: cast_nullable_to_non_nullable
                      as String,
            titleParams: null == titleParams
                ? _value.titleParams
                : titleParams // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            bodyKey: null == bodyKey
                ? _value.bodyKey
                : bodyKey // ignore: cast_nullable_to_non_nullable
                      as String,
            bodyParams: null == bodyParams
                ? _value.bodyParams
                : bodyParams // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            resourceType: freezed == resourceType
                ? _value.resourceType
                : resourceType // ignore: cast_nullable_to_non_nullable
                      as String?,
            resourceId: freezed == resourceId
                ? _value.resourceId
                : resourceId // ignore: cast_nullable_to_non_nullable
                      as String?,
            actionUrl: freezed == actionUrl
                ? _value.actionUrl
                : actionUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            readAt: freezed == readAt
                ? _value.readAt
                : readAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            archivedAt: freezed == archivedAt
                ? _value.archivedAt
                : archivedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppNotificationImplCopyWith<$Res>
    implements $AppNotificationCopyWith<$Res> {
  factory _$$AppNotificationImplCopyWith(
    _$AppNotificationImpl value,
    $Res Function(_$AppNotificationImpl) then,
  ) = __$$AppNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String eventKey,
    String? category,
    @JsonKey(unknownEnumValue: NotificationSeverity.info)
    NotificationSeverity severity,
    String titleKey,
    Map<String, dynamic> titleParams,
    String bodyKey,
    Map<String, dynamic> bodyParams,
    String? resourceType,
    String? resourceId,
    String? actionUrl,
    String? readAt,
    String? archivedAt,
    String createdAt,
  });
}

/// @nodoc
class __$$AppNotificationImplCopyWithImpl<$Res>
    extends _$AppNotificationCopyWithImpl<$Res, _$AppNotificationImpl>
    implements _$$AppNotificationImplCopyWith<$Res> {
  __$$AppNotificationImplCopyWithImpl(
    _$AppNotificationImpl _value,
    $Res Function(_$AppNotificationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppNotification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventKey = null,
    Object? category = freezed,
    Object? severity = null,
    Object? titleKey = null,
    Object? titleParams = null,
    Object? bodyKey = null,
    Object? bodyParams = null,
    Object? resourceType = freezed,
    Object? resourceId = freezed,
    Object? actionUrl = freezed,
    Object? readAt = freezed,
    Object? archivedAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$AppNotificationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        eventKey: null == eventKey
            ? _value.eventKey
            : eventKey // ignore: cast_nullable_to_non_nullable
                  as String,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        severity: null == severity
            ? _value.severity
            : severity // ignore: cast_nullable_to_non_nullable
                  as NotificationSeverity,
        titleKey: null == titleKey
            ? _value.titleKey
            : titleKey // ignore: cast_nullable_to_non_nullable
                  as String,
        titleParams: null == titleParams
            ? _value._titleParams
            : titleParams // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        bodyKey: null == bodyKey
            ? _value.bodyKey
            : bodyKey // ignore: cast_nullable_to_non_nullable
                  as String,
        bodyParams: null == bodyParams
            ? _value._bodyParams
            : bodyParams // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        resourceType: freezed == resourceType
            ? _value.resourceType
            : resourceType // ignore: cast_nullable_to_non_nullable
                  as String?,
        resourceId: freezed == resourceId
            ? _value.resourceId
            : resourceId // ignore: cast_nullable_to_non_nullable
                  as String?,
        actionUrl: freezed == actionUrl
            ? _value.actionUrl
            : actionUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        readAt: freezed == readAt
            ? _value.readAt
            : readAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        archivedAt: freezed == archivedAt
            ? _value.archivedAt
            : archivedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppNotificationImpl extends _AppNotification {
  const _$AppNotificationImpl({
    required this.id,
    required this.eventKey,
    this.category,
    @JsonKey(unknownEnumValue: NotificationSeverity.info)
    this.severity = NotificationSeverity.info,
    required this.titleKey,
    final Map<String, dynamic> titleParams = const <String, dynamic>{},
    required this.bodyKey,
    final Map<String, dynamic> bodyParams = const <String, dynamic>{},
    this.resourceType,
    this.resourceId,
    this.actionUrl,
    this.readAt,
    this.archivedAt,
    required this.createdAt,
  }) : _titleParams = titleParams,
       _bodyParams = bodyParams,
       super._();

  factory _$AppNotificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppNotificationImplFromJson(json);

  @override
  final String id;
  @override
  final String eventKey;
  @override
  final String? category;
  @override
  @JsonKey(unknownEnumValue: NotificationSeverity.info)
  final NotificationSeverity severity;
  @override
  final String titleKey;
  final Map<String, dynamic> _titleParams;
  @override
  @JsonKey()
  Map<String, dynamic> get titleParams {
    if (_titleParams is EqualUnmodifiableMapView) return _titleParams;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_titleParams);
  }

  @override
  final String bodyKey;
  final Map<String, dynamic> _bodyParams;
  @override
  @JsonKey()
  Map<String, dynamic> get bodyParams {
    if (_bodyParams is EqualUnmodifiableMapView) return _bodyParams;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_bodyParams);
  }

  @override
  final String? resourceType;
  @override
  final String? resourceId;
  @override
  final String? actionUrl;
  @override
  final String? readAt;
  @override
  final String? archivedAt;
  @override
  final String createdAt;

  @override
  String toString() {
    return 'AppNotification(id: $id, eventKey: $eventKey, category: $category, severity: $severity, titleKey: $titleKey, titleParams: $titleParams, bodyKey: $bodyKey, bodyParams: $bodyParams, resourceType: $resourceType, resourceId: $resourceId, actionUrl: $actionUrl, readAt: $readAt, archivedAt: $archivedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppNotificationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventKey, eventKey) ||
                other.eventKey == eventKey) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.titleKey, titleKey) ||
                other.titleKey == titleKey) &&
            const DeepCollectionEquality().equals(
              other._titleParams,
              _titleParams,
            ) &&
            (identical(other.bodyKey, bodyKey) || other.bodyKey == bodyKey) &&
            const DeepCollectionEquality().equals(
              other._bodyParams,
              _bodyParams,
            ) &&
            (identical(other.resourceType, resourceType) ||
                other.resourceType == resourceType) &&
            (identical(other.resourceId, resourceId) ||
                other.resourceId == resourceId) &&
            (identical(other.actionUrl, actionUrl) ||
                other.actionUrl == actionUrl) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.archivedAt, archivedAt) ||
                other.archivedAt == archivedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    eventKey,
    category,
    severity,
    titleKey,
    const DeepCollectionEquality().hash(_titleParams),
    bodyKey,
    const DeepCollectionEquality().hash(_bodyParams),
    resourceType,
    resourceId,
    actionUrl,
    readAt,
    archivedAt,
    createdAt,
  );

  /// Create a copy of AppNotification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppNotificationImplCopyWith<_$AppNotificationImpl> get copyWith =>
      __$$AppNotificationImplCopyWithImpl<_$AppNotificationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AppNotificationImplToJson(this);
  }
}

abstract class _AppNotification extends AppNotification {
  const factory _AppNotification({
    required final String id,
    required final String eventKey,
    final String? category,
    @JsonKey(unknownEnumValue: NotificationSeverity.info)
    final NotificationSeverity severity,
    required final String titleKey,
    final Map<String, dynamic> titleParams,
    required final String bodyKey,
    final Map<String, dynamic> bodyParams,
    final String? resourceType,
    final String? resourceId,
    final String? actionUrl,
    final String? readAt,
    final String? archivedAt,
    required final String createdAt,
  }) = _$AppNotificationImpl;
  const _AppNotification._() : super._();

  factory _AppNotification.fromJson(Map<String, dynamic> json) =
      _$AppNotificationImpl.fromJson;

  @override
  String get id;
  @override
  String get eventKey;
  @override
  String? get category;
  @override
  @JsonKey(unknownEnumValue: NotificationSeverity.info)
  NotificationSeverity get severity;
  @override
  String get titleKey;
  @override
  Map<String, dynamic> get titleParams;
  @override
  String get bodyKey;
  @override
  Map<String, dynamic> get bodyParams;
  @override
  String? get resourceType;
  @override
  String? get resourceId;
  @override
  String? get actionUrl;
  @override
  String? get readAt;
  @override
  String? get archivedAt;
  @override
  String get createdAt;

  /// Create a copy of AppNotification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppNotificationImplCopyWith<_$AppNotificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
