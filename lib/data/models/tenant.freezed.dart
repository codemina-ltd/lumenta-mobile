// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tenant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TenantSummary {

 String get id; String get name; String? get slug; String? get role; String? get complianceStatus; String? get suspendedReason;
/// Create a copy of TenantSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TenantSummaryCopyWith<TenantSummary> get copyWith => _$TenantSummaryCopyWithImpl<TenantSummary>(this as TenantSummary, _$identity);

  /// Serializes this TenantSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TenantSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.role, role) || other.role == role)&&(identical(other.complianceStatus, complianceStatus) || other.complianceStatus == complianceStatus)&&(identical(other.suspendedReason, suspendedReason) || other.suspendedReason == suspendedReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,slug,role,complianceStatus,suspendedReason);

@override
String toString() {
  return 'TenantSummary(id: $id, name: $name, slug: $slug, role: $role, complianceStatus: $complianceStatus, suspendedReason: $suspendedReason)';
}


}

/// @nodoc
abstract mixin class $TenantSummaryCopyWith<$Res>  {
  factory $TenantSummaryCopyWith(TenantSummary value, $Res Function(TenantSummary) _then) = _$TenantSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? slug, String? role, String? complianceStatus, String? suspendedReason
});




}
/// @nodoc
class _$TenantSummaryCopyWithImpl<$Res>
    implements $TenantSummaryCopyWith<$Res> {
  _$TenantSummaryCopyWithImpl(this._self, this._then);

  final TenantSummary _self;
  final $Res Function(TenantSummary) _then;

/// Create a copy of TenantSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? slug = freezed,Object? role = freezed,Object? complianceStatus = freezed,Object? suspendedReason = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,complianceStatus: freezed == complianceStatus ? _self.complianceStatus : complianceStatus // ignore: cast_nullable_to_non_nullable
as String?,suspendedReason: freezed == suspendedReason ? _self.suspendedReason : suspendedReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TenantSummary].
extension TenantSummaryPatterns on TenantSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TenantSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TenantSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TenantSummary value)  $default,){
final _that = this;
switch (_that) {
case _TenantSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TenantSummary value)?  $default,){
final _that = this;
switch (_that) {
case _TenantSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? slug,  String? role,  String? complianceStatus,  String? suspendedReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TenantSummary() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.role,_that.complianceStatus,_that.suspendedReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? slug,  String? role,  String? complianceStatus,  String? suspendedReason)  $default,) {final _that = this;
switch (_that) {
case _TenantSummary():
return $default(_that.id,_that.name,_that.slug,_that.role,_that.complianceStatus,_that.suspendedReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? slug,  String? role,  String? complianceStatus,  String? suspendedReason)?  $default,) {final _that = this;
switch (_that) {
case _TenantSummary() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.role,_that.complianceStatus,_that.suspendedReason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TenantSummary extends TenantSummary {
  const _TenantSummary({required this.id, required this.name, this.slug, this.role, this.complianceStatus, this.suspendedReason}): super._();
  factory _TenantSummary.fromJson(Map<String, dynamic> json) => _$TenantSummaryFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? slug;
@override final  String? role;
@override final  String? complianceStatus;
@override final  String? suspendedReason;

/// Create a copy of TenantSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TenantSummaryCopyWith<_TenantSummary> get copyWith => __$TenantSummaryCopyWithImpl<_TenantSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TenantSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TenantSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.role, role) || other.role == role)&&(identical(other.complianceStatus, complianceStatus) || other.complianceStatus == complianceStatus)&&(identical(other.suspendedReason, suspendedReason) || other.suspendedReason == suspendedReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,slug,role,complianceStatus,suspendedReason);

@override
String toString() {
  return 'TenantSummary(id: $id, name: $name, slug: $slug, role: $role, complianceStatus: $complianceStatus, suspendedReason: $suspendedReason)';
}


}

/// @nodoc
abstract mixin class _$TenantSummaryCopyWith<$Res> implements $TenantSummaryCopyWith<$Res> {
  factory _$TenantSummaryCopyWith(_TenantSummary value, $Res Function(_TenantSummary) _then) = __$TenantSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? slug, String? role, String? complianceStatus, String? suspendedReason
});




}
/// @nodoc
class __$TenantSummaryCopyWithImpl<$Res>
    implements _$TenantSummaryCopyWith<$Res> {
  __$TenantSummaryCopyWithImpl(this._self, this._then);

  final _TenantSummary _self;
  final $Res Function(_TenantSummary) _then;

/// Create a copy of TenantSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? slug = freezed,Object? role = freezed,Object? complianceStatus = freezed,Object? suspendedReason = freezed,}) {
  return _then(_TenantSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,complianceStatus: freezed == complianceStatus ? _self.complianceStatus : complianceStatus // ignore: cast_nullable_to_non_nullable
as String?,suspendedReason: freezed == suspendedReason ? _self.suspendedReason : suspendedReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
