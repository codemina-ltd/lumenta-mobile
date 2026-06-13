// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_field.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ContactField _$ContactFieldFromJson(Map<String, dynamic> json) {
  return _ContactField.fromJson(json);
}

/// @nodoc
mixin _$ContactField {
  String get id => throw _privateConstructorUsedError;
  String get key => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  List<String>? get options => throw _privateConstructorUsedError;
  bool get isRequired => throw _privateConstructorUsedError;
  int get displayOrder => throw _privateConstructorUsedError;

  /// Serializes this ContactField to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContactField
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContactFieldCopyWith<ContactField> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactFieldCopyWith<$Res> {
  factory $ContactFieldCopyWith(
    ContactField value,
    $Res Function(ContactField) then,
  ) = _$ContactFieldCopyWithImpl<$Res, ContactField>;
  @useResult
  $Res call({
    String id,
    String key,
    String label,
    String type,
    List<String>? options,
    bool isRequired,
    int displayOrder,
  });
}

/// @nodoc
class _$ContactFieldCopyWithImpl<$Res, $Val extends ContactField>
    implements $ContactFieldCopyWith<$Res> {
  _$ContactFieldCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContactField
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? key = null,
    Object? label = null,
    Object? type = null,
    Object? options = freezed,
    Object? isRequired = null,
    Object? displayOrder = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            key: null == key
                ? _value.key
                : key // ignore: cast_nullable_to_non_nullable
                      as String,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            options: freezed == options
                ? _value.options
                : options // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            isRequired: null == isRequired
                ? _value.isRequired
                : isRequired // ignore: cast_nullable_to_non_nullable
                      as bool,
            displayOrder: null == displayOrder
                ? _value.displayOrder
                : displayOrder // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ContactFieldImplCopyWith<$Res>
    implements $ContactFieldCopyWith<$Res> {
  factory _$$ContactFieldImplCopyWith(
    _$ContactFieldImpl value,
    $Res Function(_$ContactFieldImpl) then,
  ) = __$$ContactFieldImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String key,
    String label,
    String type,
    List<String>? options,
    bool isRequired,
    int displayOrder,
  });
}

/// @nodoc
class __$$ContactFieldImplCopyWithImpl<$Res>
    extends _$ContactFieldCopyWithImpl<$Res, _$ContactFieldImpl>
    implements _$$ContactFieldImplCopyWith<$Res> {
  __$$ContactFieldImplCopyWithImpl(
    _$ContactFieldImpl _value,
    $Res Function(_$ContactFieldImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContactField
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? key = null,
    Object? label = null,
    Object? type = null,
    Object? options = freezed,
    Object? isRequired = null,
    Object? displayOrder = null,
  }) {
    return _then(
      _$ContactFieldImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        key: null == key
            ? _value.key
            : key // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        options: freezed == options
            ? _value._options
            : options // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        isRequired: null == isRequired
            ? _value.isRequired
            : isRequired // ignore: cast_nullable_to_non_nullable
                  as bool,
        displayOrder: null == displayOrder
            ? _value.displayOrder
            : displayOrder // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ContactFieldImpl implements _ContactField {
  const _$ContactFieldImpl({
    required this.id,
    required this.key,
    required this.label,
    required this.type,
    final List<String>? options,
    this.isRequired = false,
    this.displayOrder = 0,
  }) : _options = options;

  factory _$ContactFieldImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactFieldImplFromJson(json);

  @override
  final String id;
  @override
  final String key;
  @override
  final String label;
  @override
  final String type;
  final List<String>? _options;
  @override
  List<String>? get options {
    final value = _options;
    if (value == null) return null;
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final bool isRequired;
  @override
  @JsonKey()
  final int displayOrder;

  @override
  String toString() {
    return 'ContactField(id: $id, key: $key, label: $label, type: $type, options: $options, isRequired: $isRequired, displayOrder: $displayOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactFieldImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.isRequired, isRequired) ||
                other.isRequired == isRequired) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    key,
    label,
    type,
    const DeepCollectionEquality().hash(_options),
    isRequired,
    displayOrder,
  );

  /// Create a copy of ContactField
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactFieldImplCopyWith<_$ContactFieldImpl> get copyWith =>
      __$$ContactFieldImplCopyWithImpl<_$ContactFieldImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactFieldImplToJson(this);
  }
}

abstract class _ContactField implements ContactField {
  const factory _ContactField({
    required final String id,
    required final String key,
    required final String label,
    required final String type,
    final List<String>? options,
    final bool isRequired,
    final int displayOrder,
  }) = _$ContactFieldImpl;

  factory _ContactField.fromJson(Map<String, dynamic> json) =
      _$ContactFieldImpl.fromJson;

  @override
  String get id;
  @override
  String get key;
  @override
  String get label;
  @override
  String get type;
  @override
  List<String>? get options;
  @override
  bool get isRequired;
  @override
  int get displayOrder;

  /// Create a copy of ContactField
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactFieldImplCopyWith<_$ContactFieldImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ContactLifecycleStage _$ContactLifecycleStageFromJson(
  Map<String, dynamic> json,
) {
  return _ContactLifecycleStage.fromJson(json);
}

/// @nodoc
mixin _$ContactLifecycleStage {
  String get id => throw _privateConstructorUsedError;
  String get key => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  int get displayOrder => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;

  /// Serializes this ContactLifecycleStage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContactLifecycleStage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContactLifecycleStageCopyWith<ContactLifecycleStage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactLifecycleStageCopyWith<$Res> {
  factory $ContactLifecycleStageCopyWith(
    ContactLifecycleStage value,
    $Res Function(ContactLifecycleStage) then,
  ) = _$ContactLifecycleStageCopyWithImpl<$Res, ContactLifecycleStage>;
  @useResult
  $Res call({
    String id,
    String key,
    String label,
    String color,
    int displayOrder,
    bool isDefault,
  });
}

/// @nodoc
class _$ContactLifecycleStageCopyWithImpl<
  $Res,
  $Val extends ContactLifecycleStage
>
    implements $ContactLifecycleStageCopyWith<$Res> {
  _$ContactLifecycleStageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContactLifecycleStage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? key = null,
    Object? label = null,
    Object? color = null,
    Object? displayOrder = null,
    Object? isDefault = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            key: null == key
                ? _value.key
                : key // ignore: cast_nullable_to_non_nullable
                      as String,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            color: null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String,
            displayOrder: null == displayOrder
                ? _value.displayOrder
                : displayOrder // ignore: cast_nullable_to_non_nullable
                      as int,
            isDefault: null == isDefault
                ? _value.isDefault
                : isDefault // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ContactLifecycleStageImplCopyWith<$Res>
    implements $ContactLifecycleStageCopyWith<$Res> {
  factory _$$ContactLifecycleStageImplCopyWith(
    _$ContactLifecycleStageImpl value,
    $Res Function(_$ContactLifecycleStageImpl) then,
  ) = __$$ContactLifecycleStageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String key,
    String label,
    String color,
    int displayOrder,
    bool isDefault,
  });
}

/// @nodoc
class __$$ContactLifecycleStageImplCopyWithImpl<$Res>
    extends
        _$ContactLifecycleStageCopyWithImpl<$Res, _$ContactLifecycleStageImpl>
    implements _$$ContactLifecycleStageImplCopyWith<$Res> {
  __$$ContactLifecycleStageImplCopyWithImpl(
    _$ContactLifecycleStageImpl _value,
    $Res Function(_$ContactLifecycleStageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContactLifecycleStage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? key = null,
    Object? label = null,
    Object? color = null,
    Object? displayOrder = null,
    Object? isDefault = null,
  }) {
    return _then(
      _$ContactLifecycleStageImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        key: null == key
            ? _value.key
            : key // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        color: null == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String,
        displayOrder: null == displayOrder
            ? _value.displayOrder
            : displayOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        isDefault: null == isDefault
            ? _value.isDefault
            : isDefault // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ContactLifecycleStageImpl implements _ContactLifecycleStage {
  const _$ContactLifecycleStageImpl({
    required this.id,
    required this.key,
    required this.label,
    this.color = '#B8A4FF',
    this.displayOrder = 0,
    this.isDefault = false,
  });

  factory _$ContactLifecycleStageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactLifecycleStageImplFromJson(json);

  @override
  final String id;
  @override
  final String key;
  @override
  final String label;
  @override
  @JsonKey()
  final String color;
  @override
  @JsonKey()
  final int displayOrder;
  @override
  @JsonKey()
  final bool isDefault;

  @override
  String toString() {
    return 'ContactLifecycleStage(id: $id, key: $key, label: $label, color: $color, displayOrder: $displayOrder, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactLifecycleStageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, key, label, color, displayOrder, isDefault);

  /// Create a copy of ContactLifecycleStage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactLifecycleStageImplCopyWith<_$ContactLifecycleStageImpl>
  get copyWith =>
      __$$ContactLifecycleStageImplCopyWithImpl<_$ContactLifecycleStageImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactLifecycleStageImplToJson(this);
  }
}

abstract class _ContactLifecycleStage implements ContactLifecycleStage {
  const factory _ContactLifecycleStage({
    required final String id,
    required final String key,
    required final String label,
    final String color,
    final int displayOrder,
    final bool isDefault,
  }) = _$ContactLifecycleStageImpl;

  factory _ContactLifecycleStage.fromJson(Map<String, dynamic> json) =
      _$ContactLifecycleStageImpl.fromJson;

  @override
  String get id;
  @override
  String get key;
  @override
  String get label;
  @override
  String get color;
  @override
  int get displayOrder;
  @override
  bool get isDefault;

  /// Create a copy of ContactLifecycleStage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactLifecycleStageImplCopyWith<_$ContactLifecycleStageImpl>
  get copyWith => throw _privateConstructorUsedError;
}
