// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sender.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Sender _$SenderFromJson(Map<String, dynamic> json) {
  return _Sender.fromJson(json);
}

/// @nodoc
mixin _$Sender {
  String get id => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  String? get displayPhoneNumber => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: SenderStatus.pending)
  SenderStatus get status => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;

  /// Serializes this Sender to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Sender
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SenderCopyWith<Sender> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SenderCopyWith<$Res> {
  factory $SenderCopyWith(Sender value, $Res Function(Sender) then) =
      _$SenderCopyWithImpl<$Res, Sender>;
  @useResult
  $Res call({
    String id,
    String displayName,
    String? phoneNumber,
    String? displayPhoneNumber,
    @JsonKey(unknownEnumValue: SenderStatus.pending) SenderStatus status,
    bool isDefault,
  });
}

/// @nodoc
class _$SenderCopyWithImpl<$Res, $Val extends Sender>
    implements $SenderCopyWith<$Res> {
  _$SenderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Sender
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = null,
    Object? phoneNumber = freezed,
    Object? displayPhoneNumber = freezed,
    Object? status = null,
    Object? isDefault = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: null == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String,
            phoneNumber: freezed == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            displayPhoneNumber: freezed == displayPhoneNumber
                ? _value.displayPhoneNumber
                : displayPhoneNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as SenderStatus,
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
abstract class _$$SenderImplCopyWith<$Res> implements $SenderCopyWith<$Res> {
  factory _$$SenderImplCopyWith(
    _$SenderImpl value,
    $Res Function(_$SenderImpl) then,
  ) = __$$SenderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String displayName,
    String? phoneNumber,
    String? displayPhoneNumber,
    @JsonKey(unknownEnumValue: SenderStatus.pending) SenderStatus status,
    bool isDefault,
  });
}

/// @nodoc
class __$$SenderImplCopyWithImpl<$Res>
    extends _$SenderCopyWithImpl<$Res, _$SenderImpl>
    implements _$$SenderImplCopyWith<$Res> {
  __$$SenderImplCopyWithImpl(
    _$SenderImpl _value,
    $Res Function(_$SenderImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Sender
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = null,
    Object? phoneNumber = freezed,
    Object? displayPhoneNumber = freezed,
    Object? status = null,
    Object? isDefault = null,
  }) {
    return _then(
      _$SenderImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: null == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String,
        phoneNumber: freezed == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        displayPhoneNumber: freezed == displayPhoneNumber
            ? _value.displayPhoneNumber
            : displayPhoneNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as SenderStatus,
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
class _$SenderImpl extends _Sender {
  const _$SenderImpl({
    required this.id,
    this.displayName = '',
    this.phoneNumber,
    this.displayPhoneNumber,
    @JsonKey(unknownEnumValue: SenderStatus.pending)
    this.status = SenderStatus.pending,
    this.isDefault = false,
  }) : super._();

  factory _$SenderImpl.fromJson(Map<String, dynamic> json) =>
      _$$SenderImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final String displayName;
  @override
  final String? phoneNumber;
  @override
  final String? displayPhoneNumber;
  @override
  @JsonKey(unknownEnumValue: SenderStatus.pending)
  final SenderStatus status;
  @override
  @JsonKey()
  final bool isDefault;

  @override
  String toString() {
    return 'Sender(id: $id, displayName: $displayName, phoneNumber: $phoneNumber, displayPhoneNumber: $displayPhoneNumber, status: $status, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SenderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.displayPhoneNumber, displayPhoneNumber) ||
                other.displayPhoneNumber == displayPhoneNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    displayName,
    phoneNumber,
    displayPhoneNumber,
    status,
    isDefault,
  );

  /// Create a copy of Sender
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SenderImplCopyWith<_$SenderImpl> get copyWith =>
      __$$SenderImplCopyWithImpl<_$SenderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SenderImplToJson(this);
  }
}

abstract class _Sender extends Sender {
  const factory _Sender({
    required final String id,
    final String displayName,
    final String? phoneNumber,
    final String? displayPhoneNumber,
    @JsonKey(unknownEnumValue: SenderStatus.pending) final SenderStatus status,
    final bool isDefault,
  }) = _$SenderImpl;
  const _Sender._() : super._();

  factory _Sender.fromJson(Map<String, dynamic> json) = _$SenderImpl.fromJson;

  @override
  String get id;
  @override
  String get displayName;
  @override
  String? get phoneNumber;
  @override
  String? get displayPhoneNumber;
  @override
  @JsonKey(unknownEnumValue: SenderStatus.pending)
  SenderStatus get status;
  @override
  bool get isDefault;

  /// Create a copy of Sender
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SenderImplCopyWith<_$SenderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
