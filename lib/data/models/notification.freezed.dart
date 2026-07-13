// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppNotification {

 String get id; String get eventKey; String? get category;@JsonKey(unknownEnumValue: NotificationSeverity.info) NotificationSeverity get severity; String get titleKey; Map<String, dynamic> get titleParams; String get bodyKey; Map<String, dynamic> get bodyParams; String? get resourceType; String? get resourceId; String? get actionUrl; String? get readAt; String? get archivedAt; String get createdAt;
/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppNotificationCopyWith<AppNotification> get copyWith => _$AppNotificationCopyWithImpl<AppNotification>(this as AppNotification, _$identity);

  /// Serializes this AppNotification to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppNotification&&(identical(other.id, id) || other.id == id)&&(identical(other.eventKey, eventKey) || other.eventKey == eventKey)&&(identical(other.category, category) || other.category == category)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.titleKey, titleKey) || other.titleKey == titleKey)&&const DeepCollectionEquality().equals(other.titleParams, titleParams)&&(identical(other.bodyKey, bodyKey) || other.bodyKey == bodyKey)&&const DeepCollectionEquality().equals(other.bodyParams, bodyParams)&&(identical(other.resourceType, resourceType) || other.resourceType == resourceType)&&(identical(other.resourceId, resourceId) || other.resourceId == resourceId)&&(identical(other.actionUrl, actionUrl) || other.actionUrl == actionUrl)&&(identical(other.readAt, readAt) || other.readAt == readAt)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,eventKey,category,severity,titleKey,const DeepCollectionEquality().hash(titleParams),bodyKey,const DeepCollectionEquality().hash(bodyParams),resourceType,resourceId,actionUrl,readAt,archivedAt,createdAt);

@override
String toString() {
  return 'AppNotification(id: $id, eventKey: $eventKey, category: $category, severity: $severity, titleKey: $titleKey, titleParams: $titleParams, bodyKey: $bodyKey, bodyParams: $bodyParams, resourceType: $resourceType, resourceId: $resourceId, actionUrl: $actionUrl, readAt: $readAt, archivedAt: $archivedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AppNotificationCopyWith<$Res>  {
  factory $AppNotificationCopyWith(AppNotification value, $Res Function(AppNotification) _then) = _$AppNotificationCopyWithImpl;
@useResult
$Res call({
 String id, String eventKey, String? category,@JsonKey(unknownEnumValue: NotificationSeverity.info) NotificationSeverity severity, String titleKey, Map<String, dynamic> titleParams, String bodyKey, Map<String, dynamic> bodyParams, String? resourceType, String? resourceId, String? actionUrl, String? readAt, String? archivedAt, String createdAt
});




}
/// @nodoc
class _$AppNotificationCopyWithImpl<$Res>
    implements $AppNotificationCopyWith<$Res> {
  _$AppNotificationCopyWithImpl(this._self, this._then);

  final AppNotification _self;
  final $Res Function(AppNotification) _then;

/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? eventKey = null,Object? category = freezed,Object? severity = null,Object? titleKey = null,Object? titleParams = null,Object? bodyKey = null,Object? bodyParams = null,Object? resourceType = freezed,Object? resourceId = freezed,Object? actionUrl = freezed,Object? readAt = freezed,Object? archivedAt = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,eventKey: null == eventKey ? _self.eventKey : eventKey // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as NotificationSeverity,titleKey: null == titleKey ? _self.titleKey : titleKey // ignore: cast_nullable_to_non_nullable
as String,titleParams: null == titleParams ? _self.titleParams : titleParams // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,bodyKey: null == bodyKey ? _self.bodyKey : bodyKey // ignore: cast_nullable_to_non_nullable
as String,bodyParams: null == bodyParams ? _self.bodyParams : bodyParams // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,resourceType: freezed == resourceType ? _self.resourceType : resourceType // ignore: cast_nullable_to_non_nullable
as String?,resourceId: freezed == resourceId ? _self.resourceId : resourceId // ignore: cast_nullable_to_non_nullable
as String?,actionUrl: freezed == actionUrl ? _self.actionUrl : actionUrl // ignore: cast_nullable_to_non_nullable
as String?,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as String?,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppNotification].
extension AppNotificationPatterns on AppNotification {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppNotification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppNotification value)  $default,){
final _that = this;
switch (_that) {
case _AppNotification():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppNotification value)?  $default,){
final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String eventKey,  String? category, @JsonKey(unknownEnumValue: NotificationSeverity.info)  NotificationSeverity severity,  String titleKey,  Map<String, dynamic> titleParams,  String bodyKey,  Map<String, dynamic> bodyParams,  String? resourceType,  String? resourceId,  String? actionUrl,  String? readAt,  String? archivedAt,  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
return $default(_that.id,_that.eventKey,_that.category,_that.severity,_that.titleKey,_that.titleParams,_that.bodyKey,_that.bodyParams,_that.resourceType,_that.resourceId,_that.actionUrl,_that.readAt,_that.archivedAt,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String eventKey,  String? category, @JsonKey(unknownEnumValue: NotificationSeverity.info)  NotificationSeverity severity,  String titleKey,  Map<String, dynamic> titleParams,  String bodyKey,  Map<String, dynamic> bodyParams,  String? resourceType,  String? resourceId,  String? actionUrl,  String? readAt,  String? archivedAt,  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _AppNotification():
return $default(_that.id,_that.eventKey,_that.category,_that.severity,_that.titleKey,_that.titleParams,_that.bodyKey,_that.bodyParams,_that.resourceType,_that.resourceId,_that.actionUrl,_that.readAt,_that.archivedAt,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String eventKey,  String? category, @JsonKey(unknownEnumValue: NotificationSeverity.info)  NotificationSeverity severity,  String titleKey,  Map<String, dynamic> titleParams,  String bodyKey,  Map<String, dynamic> bodyParams,  String? resourceType,  String? resourceId,  String? actionUrl,  String? readAt,  String? archivedAt,  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
return $default(_that.id,_that.eventKey,_that.category,_that.severity,_that.titleKey,_that.titleParams,_that.bodyKey,_that.bodyParams,_that.resourceType,_that.resourceId,_that.actionUrl,_that.readAt,_that.archivedAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppNotification extends AppNotification {
  const _AppNotification({required this.id, required this.eventKey, this.category, @JsonKey(unknownEnumValue: NotificationSeverity.info) this.severity = NotificationSeverity.info, required this.titleKey, final  Map<String, dynamic> titleParams = const <String, dynamic>{}, required this.bodyKey, final  Map<String, dynamic> bodyParams = const <String, dynamic>{}, this.resourceType, this.resourceId, this.actionUrl, this.readAt, this.archivedAt, required this.createdAt}): _titleParams = titleParams,_bodyParams = bodyParams,super._();
  factory _AppNotification.fromJson(Map<String, dynamic> json) => _$AppNotificationFromJson(json);

@override final  String id;
@override final  String eventKey;
@override final  String? category;
@override@JsonKey(unknownEnumValue: NotificationSeverity.info) final  NotificationSeverity severity;
@override final  String titleKey;
 final  Map<String, dynamic> _titleParams;
@override@JsonKey() Map<String, dynamic> get titleParams {
  if (_titleParams is EqualUnmodifiableMapView) return _titleParams;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_titleParams);
}

@override final  String bodyKey;
 final  Map<String, dynamic> _bodyParams;
@override@JsonKey() Map<String, dynamic> get bodyParams {
  if (_bodyParams is EqualUnmodifiableMapView) return _bodyParams;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_bodyParams);
}

@override final  String? resourceType;
@override final  String? resourceId;
@override final  String? actionUrl;
@override final  String? readAt;
@override final  String? archivedAt;
@override final  String createdAt;

/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppNotificationCopyWith<_AppNotification> get copyWith => __$AppNotificationCopyWithImpl<_AppNotification>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppNotificationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppNotification&&(identical(other.id, id) || other.id == id)&&(identical(other.eventKey, eventKey) || other.eventKey == eventKey)&&(identical(other.category, category) || other.category == category)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.titleKey, titleKey) || other.titleKey == titleKey)&&const DeepCollectionEquality().equals(other._titleParams, _titleParams)&&(identical(other.bodyKey, bodyKey) || other.bodyKey == bodyKey)&&const DeepCollectionEquality().equals(other._bodyParams, _bodyParams)&&(identical(other.resourceType, resourceType) || other.resourceType == resourceType)&&(identical(other.resourceId, resourceId) || other.resourceId == resourceId)&&(identical(other.actionUrl, actionUrl) || other.actionUrl == actionUrl)&&(identical(other.readAt, readAt) || other.readAt == readAt)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,eventKey,category,severity,titleKey,const DeepCollectionEquality().hash(_titleParams),bodyKey,const DeepCollectionEquality().hash(_bodyParams),resourceType,resourceId,actionUrl,readAt,archivedAt,createdAt);

@override
String toString() {
  return 'AppNotification(id: $id, eventKey: $eventKey, category: $category, severity: $severity, titleKey: $titleKey, titleParams: $titleParams, bodyKey: $bodyKey, bodyParams: $bodyParams, resourceType: $resourceType, resourceId: $resourceId, actionUrl: $actionUrl, readAt: $readAt, archivedAt: $archivedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AppNotificationCopyWith<$Res> implements $AppNotificationCopyWith<$Res> {
  factory _$AppNotificationCopyWith(_AppNotification value, $Res Function(_AppNotification) _then) = __$AppNotificationCopyWithImpl;
@override @useResult
$Res call({
 String id, String eventKey, String? category,@JsonKey(unknownEnumValue: NotificationSeverity.info) NotificationSeverity severity, String titleKey, Map<String, dynamic> titleParams, String bodyKey, Map<String, dynamic> bodyParams, String? resourceType, String? resourceId, String? actionUrl, String? readAt, String? archivedAt, String createdAt
});




}
/// @nodoc
class __$AppNotificationCopyWithImpl<$Res>
    implements _$AppNotificationCopyWith<$Res> {
  __$AppNotificationCopyWithImpl(this._self, this._then);

  final _AppNotification _self;
  final $Res Function(_AppNotification) _then;

/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? eventKey = null,Object? category = freezed,Object? severity = null,Object? titleKey = null,Object? titleParams = null,Object? bodyKey = null,Object? bodyParams = null,Object? resourceType = freezed,Object? resourceId = freezed,Object? actionUrl = freezed,Object? readAt = freezed,Object? archivedAt = freezed,Object? createdAt = null,}) {
  return _then(_AppNotification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,eventKey: null == eventKey ? _self.eventKey : eventKey // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as NotificationSeverity,titleKey: null == titleKey ? _self.titleKey : titleKey // ignore: cast_nullable_to_non_nullable
as String,titleParams: null == titleParams ? _self._titleParams : titleParams // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,bodyKey: null == bodyKey ? _self.bodyKey : bodyKey // ignore: cast_nullable_to_non_nullable
as String,bodyParams: null == bodyParams ? _self._bodyParams : bodyParams // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,resourceType: freezed == resourceType ? _self.resourceType : resourceType // ignore: cast_nullable_to_non_nullable
as String?,resourceId: freezed == resourceId ? _self.resourceId : resourceId // ignore: cast_nullable_to_non_nullable
as String?,actionUrl: freezed == actionUrl ? _self.actionUrl : actionUrl // ignore: cast_nullable_to_non_nullable
as String?,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as String?,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
