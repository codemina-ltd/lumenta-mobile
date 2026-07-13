// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_field.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContactField {

 String get id; String get key; String get label; String get type; List<String>? get options; bool get isRequired; int get displayOrder;
/// Create a copy of ContactField
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactFieldCopyWith<ContactField> get copyWith => _$ContactFieldCopyWithImpl<ContactField>(this as ContactField, _$identity);

  /// Serializes this ContactField to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactField&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,key,label,type,const DeepCollectionEquality().hash(options),isRequired,displayOrder);

@override
String toString() {
  return 'ContactField(id: $id, key: $key, label: $label, type: $type, options: $options, isRequired: $isRequired, displayOrder: $displayOrder)';
}


}

/// @nodoc
abstract mixin class $ContactFieldCopyWith<$Res>  {
  factory $ContactFieldCopyWith(ContactField value, $Res Function(ContactField) _then) = _$ContactFieldCopyWithImpl;
@useResult
$Res call({
 String id, String key, String label, String type, List<String>? options, bool isRequired, int displayOrder
});




}
/// @nodoc
class _$ContactFieldCopyWithImpl<$Res>
    implements $ContactFieldCopyWith<$Res> {
  _$ContactFieldCopyWithImpl(this._self, this._then);

  final ContactField _self;
  final $Res Function(ContactField) _then;

/// Create a copy of ContactField
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? key = null,Object? label = null,Object? type = null,Object? options = freezed,Object? isRequired = null,Object? displayOrder = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ContactField].
extension ContactFieldPatterns on ContactField {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactField value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactField() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactField value)  $default,){
final _that = this;
switch (_that) {
case _ContactField():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactField value)?  $default,){
final _that = this;
switch (_that) {
case _ContactField() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String key,  String label,  String type,  List<String>? options,  bool isRequired,  int displayOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactField() when $default != null:
return $default(_that.id,_that.key,_that.label,_that.type,_that.options,_that.isRequired,_that.displayOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String key,  String label,  String type,  List<String>? options,  bool isRequired,  int displayOrder)  $default,) {final _that = this;
switch (_that) {
case _ContactField():
return $default(_that.id,_that.key,_that.label,_that.type,_that.options,_that.isRequired,_that.displayOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String key,  String label,  String type,  List<String>? options,  bool isRequired,  int displayOrder)?  $default,) {final _that = this;
switch (_that) {
case _ContactField() when $default != null:
return $default(_that.id,_that.key,_that.label,_that.type,_that.options,_that.isRequired,_that.displayOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContactField implements ContactField {
  const _ContactField({required this.id, required this.key, required this.label, required this.type, final  List<String>? options, this.isRequired = false, this.displayOrder = 0}): _options = options;
  factory _ContactField.fromJson(Map<String, dynamic> json) => _$ContactFieldFromJson(json);

@override final  String id;
@override final  String key;
@override final  String label;
@override final  String type;
 final  List<String>? _options;
@override List<String>? get options {
  final value = _options;
  if (value == null) return null;
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  bool isRequired;
@override@JsonKey() final  int displayOrder;

/// Create a copy of ContactField
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactFieldCopyWith<_ContactField> get copyWith => __$ContactFieldCopyWithImpl<_ContactField>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContactFieldToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactField&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,key,label,type,const DeepCollectionEquality().hash(_options),isRequired,displayOrder);

@override
String toString() {
  return 'ContactField(id: $id, key: $key, label: $label, type: $type, options: $options, isRequired: $isRequired, displayOrder: $displayOrder)';
}


}

/// @nodoc
abstract mixin class _$ContactFieldCopyWith<$Res> implements $ContactFieldCopyWith<$Res> {
  factory _$ContactFieldCopyWith(_ContactField value, $Res Function(_ContactField) _then) = __$ContactFieldCopyWithImpl;
@override @useResult
$Res call({
 String id, String key, String label, String type, List<String>? options, bool isRequired, int displayOrder
});




}
/// @nodoc
class __$ContactFieldCopyWithImpl<$Res>
    implements _$ContactFieldCopyWith<$Res> {
  __$ContactFieldCopyWithImpl(this._self, this._then);

  final _ContactField _self;
  final $Res Function(_ContactField) _then;

/// Create a copy of ContactField
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? key = null,Object? label = null,Object? type = null,Object? options = freezed,Object? isRequired = null,Object? displayOrder = null,}) {
  return _then(_ContactField(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,options: freezed == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ContactLifecycleStage {

 String get id; String get key; String get label; String get color; int get displayOrder; bool get isDefault;
/// Create a copy of ContactLifecycleStage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactLifecycleStageCopyWith<ContactLifecycleStage> get copyWith => _$ContactLifecycleStageCopyWithImpl<ContactLifecycleStage>(this as ContactLifecycleStage, _$identity);

  /// Serializes this ContactLifecycleStage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactLifecycleStage&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.label, label) || other.label == label)&&(identical(other.color, color) || other.color == color)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,key,label,color,displayOrder,isDefault);

@override
String toString() {
  return 'ContactLifecycleStage(id: $id, key: $key, label: $label, color: $color, displayOrder: $displayOrder, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class $ContactLifecycleStageCopyWith<$Res>  {
  factory $ContactLifecycleStageCopyWith(ContactLifecycleStage value, $Res Function(ContactLifecycleStage) _then) = _$ContactLifecycleStageCopyWithImpl;
@useResult
$Res call({
 String id, String key, String label, String color, int displayOrder, bool isDefault
});




}
/// @nodoc
class _$ContactLifecycleStageCopyWithImpl<$Res>
    implements $ContactLifecycleStageCopyWith<$Res> {
  _$ContactLifecycleStageCopyWithImpl(this._self, this._then);

  final ContactLifecycleStage _self;
  final $Res Function(ContactLifecycleStage) _then;

/// Create a copy of ContactLifecycleStage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? key = null,Object? label = null,Object? color = null,Object? displayOrder = null,Object? isDefault = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ContactLifecycleStage].
extension ContactLifecycleStagePatterns on ContactLifecycleStage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactLifecycleStage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactLifecycleStage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactLifecycleStage value)  $default,){
final _that = this;
switch (_that) {
case _ContactLifecycleStage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactLifecycleStage value)?  $default,){
final _that = this;
switch (_that) {
case _ContactLifecycleStage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String key,  String label,  String color,  int displayOrder,  bool isDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactLifecycleStage() when $default != null:
return $default(_that.id,_that.key,_that.label,_that.color,_that.displayOrder,_that.isDefault);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String key,  String label,  String color,  int displayOrder,  bool isDefault)  $default,) {final _that = this;
switch (_that) {
case _ContactLifecycleStage():
return $default(_that.id,_that.key,_that.label,_that.color,_that.displayOrder,_that.isDefault);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String key,  String label,  String color,  int displayOrder,  bool isDefault)?  $default,) {final _that = this;
switch (_that) {
case _ContactLifecycleStage() when $default != null:
return $default(_that.id,_that.key,_that.label,_that.color,_that.displayOrder,_that.isDefault);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContactLifecycleStage implements ContactLifecycleStage {
  const _ContactLifecycleStage({required this.id, required this.key, required this.label, this.color = '#B8A4FF', this.displayOrder = 0, this.isDefault = false});
  factory _ContactLifecycleStage.fromJson(Map<String, dynamic> json) => _$ContactLifecycleStageFromJson(json);

@override final  String id;
@override final  String key;
@override final  String label;
@override@JsonKey() final  String color;
@override@JsonKey() final  int displayOrder;
@override@JsonKey() final  bool isDefault;

/// Create a copy of ContactLifecycleStage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactLifecycleStageCopyWith<_ContactLifecycleStage> get copyWith => __$ContactLifecycleStageCopyWithImpl<_ContactLifecycleStage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContactLifecycleStageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactLifecycleStage&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.label, label) || other.label == label)&&(identical(other.color, color) || other.color == color)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,key,label,color,displayOrder,isDefault);

@override
String toString() {
  return 'ContactLifecycleStage(id: $id, key: $key, label: $label, color: $color, displayOrder: $displayOrder, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$ContactLifecycleStageCopyWith<$Res> implements $ContactLifecycleStageCopyWith<$Res> {
  factory _$ContactLifecycleStageCopyWith(_ContactLifecycleStage value, $Res Function(_ContactLifecycleStage) _then) = __$ContactLifecycleStageCopyWithImpl;
@override @useResult
$Res call({
 String id, String key, String label, String color, int displayOrder, bool isDefault
});




}
/// @nodoc
class __$ContactLifecycleStageCopyWithImpl<$Res>
    implements _$ContactLifecycleStageCopyWith<$Res> {
  __$ContactLifecycleStageCopyWithImpl(this._self, this._then);

  final _ContactLifecycleStage _self;
  final $Res Function(_ContactLifecycleStage) _then;

/// Create a copy of ContactLifecycleStage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? key = null,Object? label = null,Object? color = null,Object? displayOrder = null,Object? isDefault = null,}) {
  return _then(_ContactLifecycleStage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
