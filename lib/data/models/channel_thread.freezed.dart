// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_thread.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChannelThread {

 String get id; String get channelType; String get channelAccountId; String? get serviceWindowExpiresAt; String? get lastInboundAt; String? get lastOutboundAt; String? get accountDisplayName; String get accountStatus;
/// Create a copy of ChannelThread
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChannelThreadCopyWith<ChannelThread> get copyWith => _$ChannelThreadCopyWithImpl<ChannelThread>(this as ChannelThread, _$identity);

  /// Serializes this ChannelThread to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChannelThread&&(identical(other.id, id) || other.id == id)&&(identical(other.channelType, channelType) || other.channelType == channelType)&&(identical(other.channelAccountId, channelAccountId) || other.channelAccountId == channelAccountId)&&(identical(other.serviceWindowExpiresAt, serviceWindowExpiresAt) || other.serviceWindowExpiresAt == serviceWindowExpiresAt)&&(identical(other.lastInboundAt, lastInboundAt) || other.lastInboundAt == lastInboundAt)&&(identical(other.lastOutboundAt, lastOutboundAt) || other.lastOutboundAt == lastOutboundAt)&&(identical(other.accountDisplayName, accountDisplayName) || other.accountDisplayName == accountDisplayName)&&(identical(other.accountStatus, accountStatus) || other.accountStatus == accountStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,channelType,channelAccountId,serviceWindowExpiresAt,lastInboundAt,lastOutboundAt,accountDisplayName,accountStatus);

@override
String toString() {
  return 'ChannelThread(id: $id, channelType: $channelType, channelAccountId: $channelAccountId, serviceWindowExpiresAt: $serviceWindowExpiresAt, lastInboundAt: $lastInboundAt, lastOutboundAt: $lastOutboundAt, accountDisplayName: $accountDisplayName, accountStatus: $accountStatus)';
}


}

/// @nodoc
abstract mixin class $ChannelThreadCopyWith<$Res>  {
  factory $ChannelThreadCopyWith(ChannelThread value, $Res Function(ChannelThread) _then) = _$ChannelThreadCopyWithImpl;
@useResult
$Res call({
 String id, String channelType, String channelAccountId, String? serviceWindowExpiresAt, String? lastInboundAt, String? lastOutboundAt, String? accountDisplayName, String accountStatus
});




}
/// @nodoc
class _$ChannelThreadCopyWithImpl<$Res>
    implements $ChannelThreadCopyWith<$Res> {
  _$ChannelThreadCopyWithImpl(this._self, this._then);

  final ChannelThread _self;
  final $Res Function(ChannelThread) _then;

/// Create a copy of ChannelThread
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? channelType = null,Object? channelAccountId = null,Object? serviceWindowExpiresAt = freezed,Object? lastInboundAt = freezed,Object? lastOutboundAt = freezed,Object? accountDisplayName = freezed,Object? accountStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,channelType: null == channelType ? _self.channelType : channelType // ignore: cast_nullable_to_non_nullable
as String,channelAccountId: null == channelAccountId ? _self.channelAccountId : channelAccountId // ignore: cast_nullable_to_non_nullable
as String,serviceWindowExpiresAt: freezed == serviceWindowExpiresAt ? _self.serviceWindowExpiresAt : serviceWindowExpiresAt // ignore: cast_nullable_to_non_nullable
as String?,lastInboundAt: freezed == lastInboundAt ? _self.lastInboundAt : lastInboundAt // ignore: cast_nullable_to_non_nullable
as String?,lastOutboundAt: freezed == lastOutboundAt ? _self.lastOutboundAt : lastOutboundAt // ignore: cast_nullable_to_non_nullable
as String?,accountDisplayName: freezed == accountDisplayName ? _self.accountDisplayName : accountDisplayName // ignore: cast_nullable_to_non_nullable
as String?,accountStatus: null == accountStatus ? _self.accountStatus : accountStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChannelThread].
extension ChannelThreadPatterns on ChannelThread {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChannelThread value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChannelThread() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChannelThread value)  $default,){
final _that = this;
switch (_that) {
case _ChannelThread():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChannelThread value)?  $default,){
final _that = this;
switch (_that) {
case _ChannelThread() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String channelType,  String channelAccountId,  String? serviceWindowExpiresAt,  String? lastInboundAt,  String? lastOutboundAt,  String? accountDisplayName,  String accountStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChannelThread() when $default != null:
return $default(_that.id,_that.channelType,_that.channelAccountId,_that.serviceWindowExpiresAt,_that.lastInboundAt,_that.lastOutboundAt,_that.accountDisplayName,_that.accountStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String channelType,  String channelAccountId,  String? serviceWindowExpiresAt,  String? lastInboundAt,  String? lastOutboundAt,  String? accountDisplayName,  String accountStatus)  $default,) {final _that = this;
switch (_that) {
case _ChannelThread():
return $default(_that.id,_that.channelType,_that.channelAccountId,_that.serviceWindowExpiresAt,_that.lastInboundAt,_that.lastOutboundAt,_that.accountDisplayName,_that.accountStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String channelType,  String channelAccountId,  String? serviceWindowExpiresAt,  String? lastInboundAt,  String? lastOutboundAt,  String? accountDisplayName,  String accountStatus)?  $default,) {final _that = this;
switch (_that) {
case _ChannelThread() when $default != null:
return $default(_that.id,_that.channelType,_that.channelAccountId,_that.serviceWindowExpiresAt,_that.lastInboundAt,_that.lastOutboundAt,_that.accountDisplayName,_that.accountStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChannelThread extends ChannelThread {
  const _ChannelThread({required this.id, required this.channelType, required this.channelAccountId, this.serviceWindowExpiresAt, this.lastInboundAt, this.lastOutboundAt, this.accountDisplayName, this.accountStatus = 'inactive'}): super._();
  factory _ChannelThread.fromJson(Map<String, dynamic> json) => _$ChannelThreadFromJson(json);

@override final  String id;
@override final  String channelType;
@override final  String channelAccountId;
@override final  String? serviceWindowExpiresAt;
@override final  String? lastInboundAt;
@override final  String? lastOutboundAt;
@override final  String? accountDisplayName;
@override@JsonKey() final  String accountStatus;

/// Create a copy of ChannelThread
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChannelThreadCopyWith<_ChannelThread> get copyWith => __$ChannelThreadCopyWithImpl<_ChannelThread>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChannelThreadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChannelThread&&(identical(other.id, id) || other.id == id)&&(identical(other.channelType, channelType) || other.channelType == channelType)&&(identical(other.channelAccountId, channelAccountId) || other.channelAccountId == channelAccountId)&&(identical(other.serviceWindowExpiresAt, serviceWindowExpiresAt) || other.serviceWindowExpiresAt == serviceWindowExpiresAt)&&(identical(other.lastInboundAt, lastInboundAt) || other.lastInboundAt == lastInboundAt)&&(identical(other.lastOutboundAt, lastOutboundAt) || other.lastOutboundAt == lastOutboundAt)&&(identical(other.accountDisplayName, accountDisplayName) || other.accountDisplayName == accountDisplayName)&&(identical(other.accountStatus, accountStatus) || other.accountStatus == accountStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,channelType,channelAccountId,serviceWindowExpiresAt,lastInboundAt,lastOutboundAt,accountDisplayName,accountStatus);

@override
String toString() {
  return 'ChannelThread(id: $id, channelType: $channelType, channelAccountId: $channelAccountId, serviceWindowExpiresAt: $serviceWindowExpiresAt, lastInboundAt: $lastInboundAt, lastOutboundAt: $lastOutboundAt, accountDisplayName: $accountDisplayName, accountStatus: $accountStatus)';
}


}

/// @nodoc
abstract mixin class _$ChannelThreadCopyWith<$Res> implements $ChannelThreadCopyWith<$Res> {
  factory _$ChannelThreadCopyWith(_ChannelThread value, $Res Function(_ChannelThread) _then) = __$ChannelThreadCopyWithImpl;
@override @useResult
$Res call({
 String id, String channelType, String channelAccountId, String? serviceWindowExpiresAt, String? lastInboundAt, String? lastOutboundAt, String? accountDisplayName, String accountStatus
});




}
/// @nodoc
class __$ChannelThreadCopyWithImpl<$Res>
    implements _$ChannelThreadCopyWith<$Res> {
  __$ChannelThreadCopyWithImpl(this._self, this._then);

  final _ChannelThread _self;
  final $Res Function(_ChannelThread) _then;

/// Create a copy of ChannelThread
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? channelType = null,Object? channelAccountId = null,Object? serviceWindowExpiresAt = freezed,Object? lastInboundAt = freezed,Object? lastOutboundAt = freezed,Object? accountDisplayName = freezed,Object? accountStatus = null,}) {
  return _then(_ChannelThread(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,channelType: null == channelType ? _self.channelType : channelType // ignore: cast_nullable_to_non_nullable
as String,channelAccountId: null == channelAccountId ? _self.channelAccountId : channelAccountId // ignore: cast_nullable_to_non_nullable
as String,serviceWindowExpiresAt: freezed == serviceWindowExpiresAt ? _self.serviceWindowExpiresAt : serviceWindowExpiresAt // ignore: cast_nullable_to_non_nullable
as String?,lastInboundAt: freezed == lastInboundAt ? _self.lastInboundAt : lastInboundAt // ignore: cast_nullable_to_non_nullable
as String?,lastOutboundAt: freezed == lastOutboundAt ? _self.lastOutboundAt : lastOutboundAt // ignore: cast_nullable_to_non_nullable
as String?,accountDisplayName: freezed == accountDisplayName ? _self.accountDisplayName : accountDisplayName // ignore: cast_nullable_to_non_nullable
as String?,accountStatus: null == accountStatus ? _self.accountStatus : accountStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
