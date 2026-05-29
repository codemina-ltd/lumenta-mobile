// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Conversation _$ConversationFromJson(Map<String, dynamic> json) {
  return _Conversation.fromJson(json);
}

/// @nodoc
mixin _$Conversation {
  /// Client id (the chat is keyed by client).
  @JsonKey(readValue: _clientId)
  String get clientId => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  String? get profileName => throw _privateConstructorUsedError;
  String? get lastMessageBody => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: MessageType.text)
  MessageType? get lastMessageType => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: MessageDirection.inbound)
  MessageDirection? get lastMessageDirection =>
      throw _privateConstructorUsedError;
  String? get lastMessageAt => throw _privateConstructorUsedError;

  /// Serializes this Conversation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationCopyWith<Conversation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationCopyWith<$Res> {
  factory $ConversationCopyWith(
    Conversation value,
    $Res Function(Conversation) then,
  ) = _$ConversationCopyWithImpl<$Res, Conversation>;
  @useResult
  $Res call({
    @JsonKey(readValue: _clientId) String clientId,
    String phoneNumber,
    String? profileName,
    String? lastMessageBody,
    @JsonKey(unknownEnumValue: MessageType.text) MessageType? lastMessageType,
    @JsonKey(unknownEnumValue: MessageDirection.inbound)
    MessageDirection? lastMessageDirection,
    String? lastMessageAt,
  });
}

/// @nodoc
class _$ConversationCopyWithImpl<$Res, $Val extends Conversation>
    implements $ConversationCopyWith<$Res> {
  _$ConversationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientId = null,
    Object? phoneNumber = null,
    Object? profileName = freezed,
    Object? lastMessageBody = freezed,
    Object? lastMessageType = freezed,
    Object? lastMessageDirection = freezed,
    Object? lastMessageAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            clientId: null == clientId
                ? _value.clientId
                : clientId // ignore: cast_nullable_to_non_nullable
                      as String,
            phoneNumber: null == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            profileName: freezed == profileName
                ? _value.profileName
                : profileName // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastMessageBody: freezed == lastMessageBody
                ? _value.lastMessageBody
                : lastMessageBody // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastMessageType: freezed == lastMessageType
                ? _value.lastMessageType
                : lastMessageType // ignore: cast_nullable_to_non_nullable
                      as MessageType?,
            lastMessageDirection: freezed == lastMessageDirection
                ? _value.lastMessageDirection
                : lastMessageDirection // ignore: cast_nullable_to_non_nullable
                      as MessageDirection?,
            lastMessageAt: freezed == lastMessageAt
                ? _value.lastMessageAt
                : lastMessageAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConversationImplCopyWith<$Res>
    implements $ConversationCopyWith<$Res> {
  factory _$$ConversationImplCopyWith(
    _$ConversationImpl value,
    $Res Function(_$ConversationImpl) then,
  ) = __$$ConversationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(readValue: _clientId) String clientId,
    String phoneNumber,
    String? profileName,
    String? lastMessageBody,
    @JsonKey(unknownEnumValue: MessageType.text) MessageType? lastMessageType,
    @JsonKey(unknownEnumValue: MessageDirection.inbound)
    MessageDirection? lastMessageDirection,
    String? lastMessageAt,
  });
}

/// @nodoc
class __$$ConversationImplCopyWithImpl<$Res>
    extends _$ConversationCopyWithImpl<$Res, _$ConversationImpl>
    implements _$$ConversationImplCopyWith<$Res> {
  __$$ConversationImplCopyWithImpl(
    _$ConversationImpl _value,
    $Res Function(_$ConversationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientId = null,
    Object? phoneNumber = null,
    Object? profileName = freezed,
    Object? lastMessageBody = freezed,
    Object? lastMessageType = freezed,
    Object? lastMessageDirection = freezed,
    Object? lastMessageAt = freezed,
  }) {
    return _then(
      _$ConversationImpl(
        clientId: null == clientId
            ? _value.clientId
            : clientId // ignore: cast_nullable_to_non_nullable
                  as String,
        phoneNumber: null == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        profileName: freezed == profileName
            ? _value.profileName
            : profileName // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastMessageBody: freezed == lastMessageBody
            ? _value.lastMessageBody
            : lastMessageBody // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastMessageType: freezed == lastMessageType
            ? _value.lastMessageType
            : lastMessageType // ignore: cast_nullable_to_non_nullable
                  as MessageType?,
        lastMessageDirection: freezed == lastMessageDirection
            ? _value.lastMessageDirection
            : lastMessageDirection // ignore: cast_nullable_to_non_nullable
                  as MessageDirection?,
        lastMessageAt: freezed == lastMessageAt
            ? _value.lastMessageAt
            : lastMessageAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationImpl extends _Conversation {
  const _$ConversationImpl({
    @JsonKey(readValue: _clientId) required this.clientId,
    required this.phoneNumber,
    this.profileName,
    this.lastMessageBody,
    @JsonKey(unknownEnumValue: MessageType.text) this.lastMessageType,
    @JsonKey(unknownEnumValue: MessageDirection.inbound)
    this.lastMessageDirection,
    this.lastMessageAt,
  }) : super._();

  factory _$ConversationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationImplFromJson(json);

  /// Client id (the chat is keyed by client).
  @override
  @JsonKey(readValue: _clientId)
  final String clientId;
  @override
  final String phoneNumber;
  @override
  final String? profileName;
  @override
  final String? lastMessageBody;
  @override
  @JsonKey(unknownEnumValue: MessageType.text)
  final MessageType? lastMessageType;
  @override
  @JsonKey(unknownEnumValue: MessageDirection.inbound)
  final MessageDirection? lastMessageDirection;
  @override
  final String? lastMessageAt;

  @override
  String toString() {
    return 'Conversation(clientId: $clientId, phoneNumber: $phoneNumber, profileName: $profileName, lastMessageBody: $lastMessageBody, lastMessageType: $lastMessageType, lastMessageDirection: $lastMessageDirection, lastMessageAt: $lastMessageAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationImpl &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.profileName, profileName) ||
                other.profileName == profileName) &&
            (identical(other.lastMessageBody, lastMessageBody) ||
                other.lastMessageBody == lastMessageBody) &&
            (identical(other.lastMessageType, lastMessageType) ||
                other.lastMessageType == lastMessageType) &&
            (identical(other.lastMessageDirection, lastMessageDirection) ||
                other.lastMessageDirection == lastMessageDirection) &&
            (identical(other.lastMessageAt, lastMessageAt) ||
                other.lastMessageAt == lastMessageAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    clientId,
    phoneNumber,
    profileName,
    lastMessageBody,
    lastMessageType,
    lastMessageDirection,
    lastMessageAt,
  );

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationImplCopyWith<_$ConversationImpl> get copyWith =>
      __$$ConversationImplCopyWithImpl<_$ConversationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationImplToJson(this);
  }
}

abstract class _Conversation extends Conversation {
  const factory _Conversation({
    @JsonKey(readValue: _clientId) required final String clientId,
    required final String phoneNumber,
    final String? profileName,
    final String? lastMessageBody,
    @JsonKey(unknownEnumValue: MessageType.text)
    final MessageType? lastMessageType,
    @JsonKey(unknownEnumValue: MessageDirection.inbound)
    final MessageDirection? lastMessageDirection,
    final String? lastMessageAt,
  }) = _$ConversationImpl;
  const _Conversation._() : super._();

  factory _Conversation.fromJson(Map<String, dynamic> json) =
      _$ConversationImpl.fromJson;

  /// Client id (the chat is keyed by client).
  @override
  @JsonKey(readValue: _clientId)
  String get clientId;
  @override
  String get phoneNumber;
  @override
  String? get profileName;
  @override
  String? get lastMessageBody;
  @override
  @JsonKey(unknownEnumValue: MessageType.text)
  MessageType? get lastMessageType;
  @override
  @JsonKey(unknownEnumValue: MessageDirection.inbound)
  MessageDirection? get lastMessageDirection;
  @override
  String? get lastMessageAt;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationImplCopyWith<_$ConversationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
