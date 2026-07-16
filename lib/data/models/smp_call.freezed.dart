// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'smp_call.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SmpCall {

 String get id; String get startedAt;@JsonKey(unknownEnumValue: CallDirection.unknown) CallDirection get direction; int get durationSeconds; String? get deviceIdentifier; String get clientNumber;/// Employee name as reported by the SMP device (legacy attribution).
 String? get smpEmployeeName;/// Portal user the call is attributed to, when the device is linked.
 String? get agentUserId; String? get agentName;
/// Create a copy of SmpCall
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SmpCallCopyWith<SmpCall> get copyWith => _$SmpCallCopyWithImpl<SmpCall>(this as SmpCall, _$identity);

  /// Serializes this SmpCall to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SmpCall&&(identical(other.id, id) || other.id == id)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.deviceIdentifier, deviceIdentifier) || other.deviceIdentifier == deviceIdentifier)&&(identical(other.clientNumber, clientNumber) || other.clientNumber == clientNumber)&&(identical(other.smpEmployeeName, smpEmployeeName) || other.smpEmployeeName == smpEmployeeName)&&(identical(other.agentUserId, agentUserId) || other.agentUserId == agentUserId)&&(identical(other.agentName, agentName) || other.agentName == agentName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,startedAt,direction,durationSeconds,deviceIdentifier,clientNumber,smpEmployeeName,agentUserId,agentName);

@override
String toString() {
  return 'SmpCall(id: $id, startedAt: $startedAt, direction: $direction, durationSeconds: $durationSeconds, deviceIdentifier: $deviceIdentifier, clientNumber: $clientNumber, smpEmployeeName: $smpEmployeeName, agentUserId: $agentUserId, agentName: $agentName)';
}


}

/// @nodoc
abstract mixin class $SmpCallCopyWith<$Res>  {
  factory $SmpCallCopyWith(SmpCall value, $Res Function(SmpCall) _then) = _$SmpCallCopyWithImpl;
@useResult
$Res call({
 String id, String startedAt,@JsonKey(unknownEnumValue: CallDirection.unknown) CallDirection direction, int durationSeconds, String? deviceIdentifier, String clientNumber, String? smpEmployeeName, String? agentUserId, String? agentName
});




}
/// @nodoc
class _$SmpCallCopyWithImpl<$Res>
    implements $SmpCallCopyWith<$Res> {
  _$SmpCallCopyWithImpl(this._self, this._then);

  final SmpCall _self;
  final $Res Function(SmpCall) _then;

/// Create a copy of SmpCall
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? startedAt = null,Object? direction = null,Object? durationSeconds = null,Object? deviceIdentifier = freezed,Object? clientNumber = null,Object? smpEmployeeName = freezed,Object? agentUserId = freezed,Object? agentName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as CallDirection,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,deviceIdentifier: freezed == deviceIdentifier ? _self.deviceIdentifier : deviceIdentifier // ignore: cast_nullable_to_non_nullable
as String?,clientNumber: null == clientNumber ? _self.clientNumber : clientNumber // ignore: cast_nullable_to_non_nullable
as String,smpEmployeeName: freezed == smpEmployeeName ? _self.smpEmployeeName : smpEmployeeName // ignore: cast_nullable_to_non_nullable
as String?,agentUserId: freezed == agentUserId ? _self.agentUserId : agentUserId // ignore: cast_nullable_to_non_nullable
as String?,agentName: freezed == agentName ? _self.agentName : agentName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SmpCall].
extension SmpCallPatterns on SmpCall {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SmpCall value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SmpCall() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SmpCall value)  $default,){
final _that = this;
switch (_that) {
case _SmpCall():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SmpCall value)?  $default,){
final _that = this;
switch (_that) {
case _SmpCall() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String startedAt, @JsonKey(unknownEnumValue: CallDirection.unknown)  CallDirection direction,  int durationSeconds,  String? deviceIdentifier,  String clientNumber,  String? smpEmployeeName,  String? agentUserId,  String? agentName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SmpCall() when $default != null:
return $default(_that.id,_that.startedAt,_that.direction,_that.durationSeconds,_that.deviceIdentifier,_that.clientNumber,_that.smpEmployeeName,_that.agentUserId,_that.agentName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String startedAt, @JsonKey(unknownEnumValue: CallDirection.unknown)  CallDirection direction,  int durationSeconds,  String? deviceIdentifier,  String clientNumber,  String? smpEmployeeName,  String? agentUserId,  String? agentName)  $default,) {final _that = this;
switch (_that) {
case _SmpCall():
return $default(_that.id,_that.startedAt,_that.direction,_that.durationSeconds,_that.deviceIdentifier,_that.clientNumber,_that.smpEmployeeName,_that.agentUserId,_that.agentName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String startedAt, @JsonKey(unknownEnumValue: CallDirection.unknown)  CallDirection direction,  int durationSeconds,  String? deviceIdentifier,  String clientNumber,  String? smpEmployeeName,  String? agentUserId,  String? agentName)?  $default,) {final _that = this;
switch (_that) {
case _SmpCall() when $default != null:
return $default(_that.id,_that.startedAt,_that.direction,_that.durationSeconds,_that.deviceIdentifier,_that.clientNumber,_that.smpEmployeeName,_that.agentUserId,_that.agentName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SmpCall extends SmpCall {
  const _SmpCall({required this.id, required this.startedAt, @JsonKey(unknownEnumValue: CallDirection.unknown) required this.direction, this.durationSeconds = 0, this.deviceIdentifier, required this.clientNumber, this.smpEmployeeName, this.agentUserId, this.agentName}): super._();
  factory _SmpCall.fromJson(Map<String, dynamic> json) => _$SmpCallFromJson(json);

@override final  String id;
@override final  String startedAt;
@override@JsonKey(unknownEnumValue: CallDirection.unknown) final  CallDirection direction;
@override@JsonKey() final  int durationSeconds;
@override final  String? deviceIdentifier;
@override final  String clientNumber;
/// Employee name as reported by the SMP device (legacy attribution).
@override final  String? smpEmployeeName;
/// Portal user the call is attributed to, when the device is linked.
@override final  String? agentUserId;
@override final  String? agentName;

/// Create a copy of SmpCall
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SmpCallCopyWith<_SmpCall> get copyWith => __$SmpCallCopyWithImpl<_SmpCall>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SmpCallToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SmpCall&&(identical(other.id, id) || other.id == id)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.deviceIdentifier, deviceIdentifier) || other.deviceIdentifier == deviceIdentifier)&&(identical(other.clientNumber, clientNumber) || other.clientNumber == clientNumber)&&(identical(other.smpEmployeeName, smpEmployeeName) || other.smpEmployeeName == smpEmployeeName)&&(identical(other.agentUserId, agentUserId) || other.agentUserId == agentUserId)&&(identical(other.agentName, agentName) || other.agentName == agentName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,startedAt,direction,durationSeconds,deviceIdentifier,clientNumber,smpEmployeeName,agentUserId,agentName);

@override
String toString() {
  return 'SmpCall(id: $id, startedAt: $startedAt, direction: $direction, durationSeconds: $durationSeconds, deviceIdentifier: $deviceIdentifier, clientNumber: $clientNumber, smpEmployeeName: $smpEmployeeName, agentUserId: $agentUserId, agentName: $agentName)';
}


}

/// @nodoc
abstract mixin class _$SmpCallCopyWith<$Res> implements $SmpCallCopyWith<$Res> {
  factory _$SmpCallCopyWith(_SmpCall value, $Res Function(_SmpCall) _then) = __$SmpCallCopyWithImpl;
@override @useResult
$Res call({
 String id, String startedAt,@JsonKey(unknownEnumValue: CallDirection.unknown) CallDirection direction, int durationSeconds, String? deviceIdentifier, String clientNumber, String? smpEmployeeName, String? agentUserId, String? agentName
});




}
/// @nodoc
class __$SmpCallCopyWithImpl<$Res>
    implements _$SmpCallCopyWith<$Res> {
  __$SmpCallCopyWithImpl(this._self, this._then);

  final _SmpCall _self;
  final $Res Function(_SmpCall) _then;

/// Create a copy of SmpCall
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? startedAt = null,Object? direction = null,Object? durationSeconds = null,Object? deviceIdentifier = freezed,Object? clientNumber = null,Object? smpEmployeeName = freezed,Object? agentUserId = freezed,Object? agentName = freezed,}) {
  return _then(_SmpCall(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as CallDirection,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,deviceIdentifier: freezed == deviceIdentifier ? _self.deviceIdentifier : deviceIdentifier // ignore: cast_nullable_to_non_nullable
as String?,clientNumber: null == clientNumber ? _self.clientNumber : clientNumber // ignore: cast_nullable_to_non_nullable
as String,smpEmployeeName: freezed == smpEmployeeName ? _self.smpEmployeeName : smpEmployeeName // ignore: cast_nullable_to_non_nullable
as String?,agentUserId: freezed == agentUserId ? _self.agentUserId : agentUserId // ignore: cast_nullable_to_non_nullable
as String?,agentName: freezed == agentName ? _self.agentName : agentName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
