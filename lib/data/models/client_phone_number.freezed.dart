// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'client_phone_number.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ClientPhoneNumber {

 String get id; String get clientId; String get phoneNumber; bool get isPrimary; String? get label; String? get createdAt;
/// Create a copy of ClientPhoneNumber
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClientPhoneNumberCopyWith<ClientPhoneNumber> get copyWith => _$ClientPhoneNumberCopyWithImpl<ClientPhoneNumber>(this as ClientPhoneNumber, _$identity);

  /// Serializes this ClientPhoneNumber to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClientPhoneNumber&&(identical(other.id, id) || other.id == id)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&(identical(other.label, label) || other.label == label)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clientId,phoneNumber,isPrimary,label,createdAt);

@override
String toString() {
  return 'ClientPhoneNumber(id: $id, clientId: $clientId, phoneNumber: $phoneNumber, isPrimary: $isPrimary, label: $label, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ClientPhoneNumberCopyWith<$Res>  {
  factory $ClientPhoneNumberCopyWith(ClientPhoneNumber value, $Res Function(ClientPhoneNumber) _then) = _$ClientPhoneNumberCopyWithImpl;
@useResult
$Res call({
 String id, String clientId, String phoneNumber, bool isPrimary, String? label, String? createdAt
});




}
/// @nodoc
class _$ClientPhoneNumberCopyWithImpl<$Res>
    implements $ClientPhoneNumberCopyWith<$Res> {
  _$ClientPhoneNumberCopyWithImpl(this._self, this._then);

  final ClientPhoneNumber _self;
  final $Res Function(ClientPhoneNumber) _then;

/// Create a copy of ClientPhoneNumber
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? clientId = null,Object? phoneNumber = null,Object? isPrimary = null,Object? label = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ClientPhoneNumber].
extension ClientPhoneNumberPatterns on ClientPhoneNumber {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClientPhoneNumber value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClientPhoneNumber() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClientPhoneNumber value)  $default,){
final _that = this;
switch (_that) {
case _ClientPhoneNumber():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClientPhoneNumber value)?  $default,){
final _that = this;
switch (_that) {
case _ClientPhoneNumber() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String clientId,  String phoneNumber,  bool isPrimary,  String? label,  String? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClientPhoneNumber() when $default != null:
return $default(_that.id,_that.clientId,_that.phoneNumber,_that.isPrimary,_that.label,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String clientId,  String phoneNumber,  bool isPrimary,  String? label,  String? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ClientPhoneNumber():
return $default(_that.id,_that.clientId,_that.phoneNumber,_that.isPrimary,_that.label,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String clientId,  String phoneNumber,  bool isPrimary,  String? label,  String? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ClientPhoneNumber() when $default != null:
return $default(_that.id,_that.clientId,_that.phoneNumber,_that.isPrimary,_that.label,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClientPhoneNumber extends ClientPhoneNumber {
  const _ClientPhoneNumber({required this.id, required this.clientId, required this.phoneNumber, this.isPrimary = false, this.label, this.createdAt}): super._();
  factory _ClientPhoneNumber.fromJson(Map<String, dynamic> json) => _$ClientPhoneNumberFromJson(json);

@override final  String id;
@override final  String clientId;
@override final  String phoneNumber;
@override@JsonKey() final  bool isPrimary;
@override final  String? label;
@override final  String? createdAt;

/// Create a copy of ClientPhoneNumber
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClientPhoneNumberCopyWith<_ClientPhoneNumber> get copyWith => __$ClientPhoneNumberCopyWithImpl<_ClientPhoneNumber>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClientPhoneNumberToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClientPhoneNumber&&(identical(other.id, id) || other.id == id)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&(identical(other.label, label) || other.label == label)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clientId,phoneNumber,isPrimary,label,createdAt);

@override
String toString() {
  return 'ClientPhoneNumber(id: $id, clientId: $clientId, phoneNumber: $phoneNumber, isPrimary: $isPrimary, label: $label, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ClientPhoneNumberCopyWith<$Res> implements $ClientPhoneNumberCopyWith<$Res> {
  factory _$ClientPhoneNumberCopyWith(_ClientPhoneNumber value, $Res Function(_ClientPhoneNumber) _then) = __$ClientPhoneNumberCopyWithImpl;
@override @useResult
$Res call({
 String id, String clientId, String phoneNumber, bool isPrimary, String? label, String? createdAt
});




}
/// @nodoc
class __$ClientPhoneNumberCopyWithImpl<$Res>
    implements _$ClientPhoneNumberCopyWith<$Res> {
  __$ClientPhoneNumberCopyWithImpl(this._self, this._then);

  final _ClientPhoneNumber _self;
  final $Res Function(_ClientPhoneNumber) _then;

/// Create a copy of ClientPhoneNumber
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? clientId = null,Object? phoneNumber = null,Object? isPrimary = null,Object? label = freezed,Object? createdAt = freezed,}) {
  return _then(_ClientPhoneNumber(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
