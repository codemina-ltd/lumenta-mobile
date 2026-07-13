// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContactProfile {

 String get id; String get clientId; String? get lifecycleStageId; String? get source; String? get displayName; String? get locale; bool get optInMarketing; String? get optInAt; String? get firstContactedAt; String? get lastContactedAt;
/// Create a copy of ContactProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactProfileCopyWith<ContactProfile> get copyWith => _$ContactProfileCopyWithImpl<ContactProfile>(this as ContactProfile, _$identity);

  /// Serializes this ContactProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.lifecycleStageId, lifecycleStageId) || other.lifecycleStageId == lifecycleStageId)&&(identical(other.source, source) || other.source == source)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.optInMarketing, optInMarketing) || other.optInMarketing == optInMarketing)&&(identical(other.optInAt, optInAt) || other.optInAt == optInAt)&&(identical(other.firstContactedAt, firstContactedAt) || other.firstContactedAt == firstContactedAt)&&(identical(other.lastContactedAt, lastContactedAt) || other.lastContactedAt == lastContactedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clientId,lifecycleStageId,source,displayName,locale,optInMarketing,optInAt,firstContactedAt,lastContactedAt);

@override
String toString() {
  return 'ContactProfile(id: $id, clientId: $clientId, lifecycleStageId: $lifecycleStageId, source: $source, displayName: $displayName, locale: $locale, optInMarketing: $optInMarketing, optInAt: $optInAt, firstContactedAt: $firstContactedAt, lastContactedAt: $lastContactedAt)';
}


}

/// @nodoc
abstract mixin class $ContactProfileCopyWith<$Res>  {
  factory $ContactProfileCopyWith(ContactProfile value, $Res Function(ContactProfile) _then) = _$ContactProfileCopyWithImpl;
@useResult
$Res call({
 String id, String clientId, String? lifecycleStageId, String? source, String? displayName, String? locale, bool optInMarketing, String? optInAt, String? firstContactedAt, String? lastContactedAt
});




}
/// @nodoc
class _$ContactProfileCopyWithImpl<$Res>
    implements $ContactProfileCopyWith<$Res> {
  _$ContactProfileCopyWithImpl(this._self, this._then);

  final ContactProfile _self;
  final $Res Function(ContactProfile) _then;

/// Create a copy of ContactProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? clientId = null,Object? lifecycleStageId = freezed,Object? source = freezed,Object? displayName = freezed,Object? locale = freezed,Object? optInMarketing = null,Object? optInAt = freezed,Object? firstContactedAt = freezed,Object? lastContactedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,lifecycleStageId: freezed == lifecycleStageId ? _self.lifecycleStageId : lifecycleStageId // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,optInMarketing: null == optInMarketing ? _self.optInMarketing : optInMarketing // ignore: cast_nullable_to_non_nullable
as bool,optInAt: freezed == optInAt ? _self.optInAt : optInAt // ignore: cast_nullable_to_non_nullable
as String?,firstContactedAt: freezed == firstContactedAt ? _self.firstContactedAt : firstContactedAt // ignore: cast_nullable_to_non_nullable
as String?,lastContactedAt: freezed == lastContactedAt ? _self.lastContactedAt : lastContactedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ContactProfile].
extension ContactProfilePatterns on ContactProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactProfile value)  $default,){
final _that = this;
switch (_that) {
case _ContactProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactProfile value)?  $default,){
final _that = this;
switch (_that) {
case _ContactProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String clientId,  String? lifecycleStageId,  String? source,  String? displayName,  String? locale,  bool optInMarketing,  String? optInAt,  String? firstContactedAt,  String? lastContactedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactProfile() when $default != null:
return $default(_that.id,_that.clientId,_that.lifecycleStageId,_that.source,_that.displayName,_that.locale,_that.optInMarketing,_that.optInAt,_that.firstContactedAt,_that.lastContactedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String clientId,  String? lifecycleStageId,  String? source,  String? displayName,  String? locale,  bool optInMarketing,  String? optInAt,  String? firstContactedAt,  String? lastContactedAt)  $default,) {final _that = this;
switch (_that) {
case _ContactProfile():
return $default(_that.id,_that.clientId,_that.lifecycleStageId,_that.source,_that.displayName,_that.locale,_that.optInMarketing,_that.optInAt,_that.firstContactedAt,_that.lastContactedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String clientId,  String? lifecycleStageId,  String? source,  String? displayName,  String? locale,  bool optInMarketing,  String? optInAt,  String? firstContactedAt,  String? lastContactedAt)?  $default,) {final _that = this;
switch (_that) {
case _ContactProfile() when $default != null:
return $default(_that.id,_that.clientId,_that.lifecycleStageId,_that.source,_that.displayName,_that.locale,_that.optInMarketing,_that.optInAt,_that.firstContactedAt,_that.lastContactedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContactProfile implements ContactProfile {
  const _ContactProfile({required this.id, required this.clientId, this.lifecycleStageId, this.source, this.displayName, this.locale, this.optInMarketing = false, this.optInAt, this.firstContactedAt, this.lastContactedAt});
  factory _ContactProfile.fromJson(Map<String, dynamic> json) => _$ContactProfileFromJson(json);

@override final  String id;
@override final  String clientId;
@override final  String? lifecycleStageId;
@override final  String? source;
@override final  String? displayName;
@override final  String? locale;
@override@JsonKey() final  bool optInMarketing;
@override final  String? optInAt;
@override final  String? firstContactedAt;
@override final  String? lastContactedAt;

/// Create a copy of ContactProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactProfileCopyWith<_ContactProfile> get copyWith => __$ContactProfileCopyWithImpl<_ContactProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContactProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.lifecycleStageId, lifecycleStageId) || other.lifecycleStageId == lifecycleStageId)&&(identical(other.source, source) || other.source == source)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.optInMarketing, optInMarketing) || other.optInMarketing == optInMarketing)&&(identical(other.optInAt, optInAt) || other.optInAt == optInAt)&&(identical(other.firstContactedAt, firstContactedAt) || other.firstContactedAt == firstContactedAt)&&(identical(other.lastContactedAt, lastContactedAt) || other.lastContactedAt == lastContactedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clientId,lifecycleStageId,source,displayName,locale,optInMarketing,optInAt,firstContactedAt,lastContactedAt);

@override
String toString() {
  return 'ContactProfile(id: $id, clientId: $clientId, lifecycleStageId: $lifecycleStageId, source: $source, displayName: $displayName, locale: $locale, optInMarketing: $optInMarketing, optInAt: $optInAt, firstContactedAt: $firstContactedAt, lastContactedAt: $lastContactedAt)';
}


}

/// @nodoc
abstract mixin class _$ContactProfileCopyWith<$Res> implements $ContactProfileCopyWith<$Res> {
  factory _$ContactProfileCopyWith(_ContactProfile value, $Res Function(_ContactProfile) _then) = __$ContactProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String clientId, String? lifecycleStageId, String? source, String? displayName, String? locale, bool optInMarketing, String? optInAt, String? firstContactedAt, String? lastContactedAt
});




}
/// @nodoc
class __$ContactProfileCopyWithImpl<$Res>
    implements _$ContactProfileCopyWith<$Res> {
  __$ContactProfileCopyWithImpl(this._self, this._then);

  final _ContactProfile _self;
  final $Res Function(_ContactProfile) _then;

/// Create a copy of ContactProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? clientId = null,Object? lifecycleStageId = freezed,Object? source = freezed,Object? displayName = freezed,Object? locale = freezed,Object? optInMarketing = null,Object? optInAt = freezed,Object? firstContactedAt = freezed,Object? lastContactedAt = freezed,}) {
  return _then(_ContactProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,lifecycleStageId: freezed == lifecycleStageId ? _self.lifecycleStageId : lifecycleStageId // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,optInMarketing: null == optInMarketing ? _self.optInMarketing : optInMarketing // ignore: cast_nullable_to_non_nullable
as bool,optInAt: freezed == optInAt ? _self.optInAt : optInAt // ignore: cast_nullable_to_non_nullable
as String?,firstContactedAt: freezed == firstContactedAt ? _self.firstContactedAt : firstContactedAt // ignore: cast_nullable_to_non_nullable
as String?,lastContactedAt: freezed == lastContactedAt ? _self.lastContactedAt : lastContactedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ContactProfileResponse {

 ContactProfile? get profile; Map<String, String> get fieldValues;
/// Create a copy of ContactProfileResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactProfileResponseCopyWith<ContactProfileResponse> get copyWith => _$ContactProfileResponseCopyWithImpl<ContactProfileResponse>(this as ContactProfileResponse, _$identity);

  /// Serializes this ContactProfileResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactProfileResponse&&(identical(other.profile, profile) || other.profile == profile)&&const DeepCollectionEquality().equals(other.fieldValues, fieldValues));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,profile,const DeepCollectionEquality().hash(fieldValues));

@override
String toString() {
  return 'ContactProfileResponse(profile: $profile, fieldValues: $fieldValues)';
}


}

/// @nodoc
abstract mixin class $ContactProfileResponseCopyWith<$Res>  {
  factory $ContactProfileResponseCopyWith(ContactProfileResponse value, $Res Function(ContactProfileResponse) _then) = _$ContactProfileResponseCopyWithImpl;
@useResult
$Res call({
 ContactProfile? profile, Map<String, String> fieldValues
});


$ContactProfileCopyWith<$Res>? get profile;

}
/// @nodoc
class _$ContactProfileResponseCopyWithImpl<$Res>
    implements $ContactProfileResponseCopyWith<$Res> {
  _$ContactProfileResponseCopyWithImpl(this._self, this._then);

  final ContactProfileResponse _self;
  final $Res Function(ContactProfileResponse) _then;

/// Create a copy of ContactProfileResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profile = freezed,Object? fieldValues = null,}) {
  return _then(_self.copyWith(
profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as ContactProfile?,fieldValues: null == fieldValues ? _self.fieldValues : fieldValues // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}
/// Create a copy of ContactProfileResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContactProfileCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $ContactProfileCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// Adds pattern-matching-related methods to [ContactProfileResponse].
extension ContactProfileResponsePatterns on ContactProfileResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactProfileResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactProfileResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactProfileResponse value)  $default,){
final _that = this;
switch (_that) {
case _ContactProfileResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactProfileResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ContactProfileResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ContactProfile? profile,  Map<String, String> fieldValues)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactProfileResponse() when $default != null:
return $default(_that.profile,_that.fieldValues);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ContactProfile? profile,  Map<String, String> fieldValues)  $default,) {final _that = this;
switch (_that) {
case _ContactProfileResponse():
return $default(_that.profile,_that.fieldValues);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ContactProfile? profile,  Map<String, String> fieldValues)?  $default,) {final _that = this;
switch (_that) {
case _ContactProfileResponse() when $default != null:
return $default(_that.profile,_that.fieldValues);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContactProfileResponse implements ContactProfileResponse {
  const _ContactProfileResponse({this.profile, final  Map<String, String> fieldValues = const <String, String>{}}): _fieldValues = fieldValues;
  factory _ContactProfileResponse.fromJson(Map<String, dynamic> json) => _$ContactProfileResponseFromJson(json);

@override final  ContactProfile? profile;
 final  Map<String, String> _fieldValues;
@override@JsonKey() Map<String, String> get fieldValues {
  if (_fieldValues is EqualUnmodifiableMapView) return _fieldValues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_fieldValues);
}


/// Create a copy of ContactProfileResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactProfileResponseCopyWith<_ContactProfileResponse> get copyWith => __$ContactProfileResponseCopyWithImpl<_ContactProfileResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContactProfileResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactProfileResponse&&(identical(other.profile, profile) || other.profile == profile)&&const DeepCollectionEquality().equals(other._fieldValues, _fieldValues));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,profile,const DeepCollectionEquality().hash(_fieldValues));

@override
String toString() {
  return 'ContactProfileResponse(profile: $profile, fieldValues: $fieldValues)';
}


}

/// @nodoc
abstract mixin class _$ContactProfileResponseCopyWith<$Res> implements $ContactProfileResponseCopyWith<$Res> {
  factory _$ContactProfileResponseCopyWith(_ContactProfileResponse value, $Res Function(_ContactProfileResponse) _then) = __$ContactProfileResponseCopyWithImpl;
@override @useResult
$Res call({
 ContactProfile? profile, Map<String, String> fieldValues
});


@override $ContactProfileCopyWith<$Res>? get profile;

}
/// @nodoc
class __$ContactProfileResponseCopyWithImpl<$Res>
    implements _$ContactProfileResponseCopyWith<$Res> {
  __$ContactProfileResponseCopyWithImpl(this._self, this._then);

  final _ContactProfileResponse _self;
  final $Res Function(_ContactProfileResponse) _then;

/// Create a copy of ContactProfileResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profile = freezed,Object? fieldValues = null,}) {
  return _then(_ContactProfileResponse(
profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as ContactProfile?,fieldValues: null == fieldValues ? _self._fieldValues : fieldValues // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

/// Create a copy of ContactProfileResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContactProfileCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $ContactProfileCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}

// dart format on
