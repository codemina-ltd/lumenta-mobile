// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inbox_label.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

InboxLabel _$InboxLabelFromJson(Map<String, dynamic> json) {
  return _InboxLabel.fromJson(json);
}

/// @nodoc
mixin _$InboxLabel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;

  /// Serializes this InboxLabel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InboxLabel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InboxLabelCopyWith<InboxLabel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InboxLabelCopyWith<$Res> {
  factory $InboxLabelCopyWith(
    InboxLabel value,
    $Res Function(InboxLabel) then,
  ) = _$InboxLabelCopyWithImpl<$Res, InboxLabel>;
  @useResult
  $Res call({String id, String name, String color});
}

/// @nodoc
class _$InboxLabelCopyWithImpl<$Res, $Val extends InboxLabel>
    implements $InboxLabelCopyWith<$Res> {
  _$InboxLabelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InboxLabel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? color = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            color: null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InboxLabelImplCopyWith<$Res>
    implements $InboxLabelCopyWith<$Res> {
  factory _$$InboxLabelImplCopyWith(
    _$InboxLabelImpl value,
    $Res Function(_$InboxLabelImpl) then,
  ) = __$$InboxLabelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String color});
}

/// @nodoc
class __$$InboxLabelImplCopyWithImpl<$Res>
    extends _$InboxLabelCopyWithImpl<$Res, _$InboxLabelImpl>
    implements _$$InboxLabelImplCopyWith<$Res> {
  __$$InboxLabelImplCopyWithImpl(
    _$InboxLabelImpl _value,
    $Res Function(_$InboxLabelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InboxLabel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? color = null}) {
    return _then(
      _$InboxLabelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        color: null == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InboxLabelImpl implements _InboxLabel {
  const _$InboxLabelImpl({
    required this.id,
    required this.name,
    this.color = '#00C896',
  });

  factory _$InboxLabelImpl.fromJson(Map<String, dynamic> json) =>
      _$$InboxLabelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final String color;

  @override
  String toString() {
    return 'InboxLabel(id: $id, name: $name, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InboxLabelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, color);

  /// Create a copy of InboxLabel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InboxLabelImplCopyWith<_$InboxLabelImpl> get copyWith =>
      __$$InboxLabelImplCopyWithImpl<_$InboxLabelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InboxLabelImplToJson(this);
  }
}

abstract class _InboxLabel implements InboxLabel {
  const factory _InboxLabel({
    required final String id,
    required final String name,
    final String color,
  }) = _$InboxLabelImpl;

  factory _InboxLabel.fromJson(Map<String, dynamic> json) =
      _$InboxLabelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get color;

  /// Create a copy of InboxLabel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InboxLabelImplCopyWith<_$InboxLabelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
