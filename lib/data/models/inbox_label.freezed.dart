// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inbox_label.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InboxLabel {

 String get id; String get name; String get color;
/// Create a copy of InboxLabel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InboxLabelCopyWith<InboxLabel> get copyWith => _$InboxLabelCopyWithImpl<InboxLabel>(this as InboxLabel, _$identity);

  /// Serializes this InboxLabel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InboxLabel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,color);

@override
String toString() {
  return 'InboxLabel(id: $id, name: $name, color: $color)';
}


}

/// @nodoc
abstract mixin class $InboxLabelCopyWith<$Res>  {
  factory $InboxLabelCopyWith(InboxLabel value, $Res Function(InboxLabel) _then) = _$InboxLabelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String color
});




}
/// @nodoc
class _$InboxLabelCopyWithImpl<$Res>
    implements $InboxLabelCopyWith<$Res> {
  _$InboxLabelCopyWithImpl(this._self, this._then);

  final InboxLabel _self;
  final $Res Function(InboxLabel) _then;

/// Create a copy of InboxLabel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? color = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [InboxLabel].
extension InboxLabelPatterns on InboxLabel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InboxLabel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InboxLabel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InboxLabel value)  $default,){
final _that = this;
switch (_that) {
case _InboxLabel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InboxLabel value)?  $default,){
final _that = this;
switch (_that) {
case _InboxLabel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String color)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InboxLabel() when $default != null:
return $default(_that.id,_that.name,_that.color);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String color)  $default,) {final _that = this;
switch (_that) {
case _InboxLabel():
return $default(_that.id,_that.name,_that.color);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String color)?  $default,) {final _that = this;
switch (_that) {
case _InboxLabel() when $default != null:
return $default(_that.id,_that.name,_that.color);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InboxLabel implements InboxLabel {
  const _InboxLabel({required this.id, required this.name, this.color = '#00C896'});
  factory _InboxLabel.fromJson(Map<String, dynamic> json) => _$InboxLabelFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  String color;

/// Create a copy of InboxLabel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InboxLabelCopyWith<_InboxLabel> get copyWith => __$InboxLabelCopyWithImpl<_InboxLabel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InboxLabelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InboxLabel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,color);

@override
String toString() {
  return 'InboxLabel(id: $id, name: $name, color: $color)';
}


}

/// @nodoc
abstract mixin class _$InboxLabelCopyWith<$Res> implements $InboxLabelCopyWith<$Res> {
  factory _$InboxLabelCopyWith(_InboxLabel value, $Res Function(_InboxLabel) _then) = __$InboxLabelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String color
});




}
/// @nodoc
class __$InboxLabelCopyWithImpl<$Res>
    implements _$InboxLabelCopyWith<$Res> {
  __$InboxLabelCopyWithImpl(this._self, this._then);

  final _InboxLabel _self;
  final $Res Function(_InboxLabel) _then;

/// Create a copy of InboxLabel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? color = null,}) {
  return _then(_InboxLabel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
