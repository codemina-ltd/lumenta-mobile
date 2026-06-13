// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_sender.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ConversationSender _$ConversationSenderFromJson(Map<String, dynamic> json) {
  return _ConversationSender.fromJson(json);
}

/// @nodoc
mixin _$ConversationSender {
  String get senderId => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  String? get displayPhoneNumber => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: SenderStatus.pending)
  SenderStatus get senderStatus => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  int get messageCount => throw _privateConstructorUsedError;
  String? get lastMessageAt => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: MessageDirection.inbound)
  MessageDirection? get lastMessageDirection =>
      throw _privateConstructorUsedError;

  /// Serializes this ConversationSender to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConversationSender
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationSenderCopyWith<ConversationSender> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationSenderCopyWith<$Res> {
  factory $ConversationSenderCopyWith(
    ConversationSender value,
    $Res Function(ConversationSender) then,
  ) = _$ConversationSenderCopyWithImpl<$Res, ConversationSender>;
  @useResult
  $Res call({
    String senderId,
    String? displayName,
    String? displayPhoneNumber,
    @JsonKey(unknownEnumValue: SenderStatus.pending) SenderStatus senderStatus,
    bool isDefault,
    int messageCount,
    String? lastMessageAt,
    @JsonKey(unknownEnumValue: MessageDirection.inbound)
    MessageDirection? lastMessageDirection,
  });
}

/// @nodoc
class _$ConversationSenderCopyWithImpl<$Res, $Val extends ConversationSender>
    implements $ConversationSenderCopyWith<$Res> {
  _$ConversationSenderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConversationSender
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? senderId = null,
    Object? displayName = freezed,
    Object? displayPhoneNumber = freezed,
    Object? senderStatus = null,
    Object? isDefault = null,
    Object? messageCount = null,
    Object? lastMessageAt = freezed,
    Object? lastMessageDirection = freezed,
  }) {
    return _then(
      _value.copyWith(
            senderId: null == senderId
                ? _value.senderId
                : senderId // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: freezed == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String?,
            displayPhoneNumber: freezed == displayPhoneNumber
                ? _value.displayPhoneNumber
                : displayPhoneNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            senderStatus: null == senderStatus
                ? _value.senderStatus
                : senderStatus // ignore: cast_nullable_to_non_nullable
                      as SenderStatus,
            isDefault: null == isDefault
                ? _value.isDefault
                : isDefault // ignore: cast_nullable_to_non_nullable
                      as bool,
            messageCount: null == messageCount
                ? _value.messageCount
                : messageCount // ignore: cast_nullable_to_non_nullable
                      as int,
            lastMessageAt: freezed == lastMessageAt
                ? _value.lastMessageAt
                : lastMessageAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastMessageDirection: freezed == lastMessageDirection
                ? _value.lastMessageDirection
                : lastMessageDirection // ignore: cast_nullable_to_non_nullable
                      as MessageDirection?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConversationSenderImplCopyWith<$Res>
    implements $ConversationSenderCopyWith<$Res> {
  factory _$$ConversationSenderImplCopyWith(
    _$ConversationSenderImpl value,
    $Res Function(_$ConversationSenderImpl) then,
  ) = __$$ConversationSenderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String senderId,
    String? displayName,
    String? displayPhoneNumber,
    @JsonKey(unknownEnumValue: SenderStatus.pending) SenderStatus senderStatus,
    bool isDefault,
    int messageCount,
    String? lastMessageAt,
    @JsonKey(unknownEnumValue: MessageDirection.inbound)
    MessageDirection? lastMessageDirection,
  });
}

/// @nodoc
class __$$ConversationSenderImplCopyWithImpl<$Res>
    extends _$ConversationSenderCopyWithImpl<$Res, _$ConversationSenderImpl>
    implements _$$ConversationSenderImplCopyWith<$Res> {
  __$$ConversationSenderImplCopyWithImpl(
    _$ConversationSenderImpl _value,
    $Res Function(_$ConversationSenderImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConversationSender
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? senderId = null,
    Object? displayName = freezed,
    Object? displayPhoneNumber = freezed,
    Object? senderStatus = null,
    Object? isDefault = null,
    Object? messageCount = null,
    Object? lastMessageAt = freezed,
    Object? lastMessageDirection = freezed,
  }) {
    return _then(
      _$ConversationSenderImpl(
        senderId: null == senderId
            ? _value.senderId
            : senderId // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: freezed == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String?,
        displayPhoneNumber: freezed == displayPhoneNumber
            ? _value.displayPhoneNumber
            : displayPhoneNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        senderStatus: null == senderStatus
            ? _value.senderStatus
            : senderStatus // ignore: cast_nullable_to_non_nullable
                  as SenderStatus,
        isDefault: null == isDefault
            ? _value.isDefault
            : isDefault // ignore: cast_nullable_to_non_nullable
                  as bool,
        messageCount: null == messageCount
            ? _value.messageCount
            : messageCount // ignore: cast_nullable_to_non_nullable
                  as int,
        lastMessageAt: freezed == lastMessageAt
            ? _value.lastMessageAt
            : lastMessageAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastMessageDirection: freezed == lastMessageDirection
            ? _value.lastMessageDirection
            : lastMessageDirection // ignore: cast_nullable_to_non_nullable
                  as MessageDirection?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationSenderImpl extends _ConversationSender {
  const _$ConversationSenderImpl({
    required this.senderId,
    this.displayName,
    this.displayPhoneNumber,
    @JsonKey(unknownEnumValue: SenderStatus.pending)
    this.senderStatus = SenderStatus.pending,
    this.isDefault = false,
    this.messageCount = 0,
    this.lastMessageAt,
    @JsonKey(unknownEnumValue: MessageDirection.inbound)
    this.lastMessageDirection,
  }) : super._();

  factory _$ConversationSenderImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationSenderImplFromJson(json);

  @override
  final String senderId;
  @override
  final String? displayName;
  @override
  final String? displayPhoneNumber;
  @override
  @JsonKey(unknownEnumValue: SenderStatus.pending)
  final SenderStatus senderStatus;
  @override
  @JsonKey()
  final bool isDefault;
  @override
  @JsonKey()
  final int messageCount;
  @override
  final String? lastMessageAt;
  @override
  @JsonKey(unknownEnumValue: MessageDirection.inbound)
  final MessageDirection? lastMessageDirection;

  @override
  String toString() {
    return 'ConversationSender(senderId: $senderId, displayName: $displayName, displayPhoneNumber: $displayPhoneNumber, senderStatus: $senderStatus, isDefault: $isDefault, messageCount: $messageCount, lastMessageAt: $lastMessageAt, lastMessageDirection: $lastMessageDirection)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationSenderImpl &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.displayPhoneNumber, displayPhoneNumber) ||
                other.displayPhoneNumber == displayPhoneNumber) &&
            (identical(other.senderStatus, senderStatus) ||
                other.senderStatus == senderStatus) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.messageCount, messageCount) ||
                other.messageCount == messageCount) &&
            (identical(other.lastMessageAt, lastMessageAt) ||
                other.lastMessageAt == lastMessageAt) &&
            (identical(other.lastMessageDirection, lastMessageDirection) ||
                other.lastMessageDirection == lastMessageDirection));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    senderId,
    displayName,
    displayPhoneNumber,
    senderStatus,
    isDefault,
    messageCount,
    lastMessageAt,
    lastMessageDirection,
  );

  /// Create a copy of ConversationSender
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationSenderImplCopyWith<_$ConversationSenderImpl> get copyWith =>
      __$$ConversationSenderImplCopyWithImpl<_$ConversationSenderImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationSenderImplToJson(this);
  }
}

abstract class _ConversationSender extends ConversationSender {
  const factory _ConversationSender({
    required final String senderId,
    final String? displayName,
    final String? displayPhoneNumber,
    @JsonKey(unknownEnumValue: SenderStatus.pending)
    final SenderStatus senderStatus,
    final bool isDefault,
    final int messageCount,
    final String? lastMessageAt,
    @JsonKey(unknownEnumValue: MessageDirection.inbound)
    final MessageDirection? lastMessageDirection,
  }) = _$ConversationSenderImpl;
  const _ConversationSender._() : super._();

  factory _ConversationSender.fromJson(Map<String, dynamic> json) =
      _$ConversationSenderImpl.fromJson;

  @override
  String get senderId;
  @override
  String? get displayName;
  @override
  String? get displayPhoneNumber;
  @override
  @JsonKey(unknownEnumValue: SenderStatus.pending)
  SenderStatus get senderStatus;
  @override
  bool get isDefault;
  @override
  int get messageCount;
  @override
  String? get lastMessageAt;
  @override
  @JsonKey(unknownEnumValue: MessageDirection.inbound)
  MessageDirection? get lastMessageDirection;

  /// Create a copy of ConversationSender
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationSenderImplCopyWith<_$ConversationSenderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
