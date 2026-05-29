// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Message _$MessageFromJson(Map<String, dynamic> json) {
  return _Message.fromJson(json);
}

/// @nodoc
mixin _$Message {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: MessageDirection.inbound)
  MessageDirection get direction => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: MessageStatus.sent)
  MessageStatus get status => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: MessageType.unknown)
  MessageType get messageType => throw _privateConstructorUsedError;
  String? get mediaUrl => throw _privateConstructorUsedError;
  String? get mediaMimeType => throw _privateConstructorUsedError;
  String? get locationLatitude => throw _privateConstructorUsedError;
  String? get locationLongitude => throw _privateConstructorUsedError;
  String? get locationName => throw _privateConstructorUsedError;
  String? get locationAddress => throw _privateConstructorUsedError;
  String? get transcription => throw _privateConstructorUsedError;
  String? get transcriptionStatus => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Message to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageCopyWith<Message> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageCopyWith<$Res> {
  factory $MessageCopyWith(Message value, $Res Function(Message) then) =
      _$MessageCopyWithImpl<$Res, Message>;
  @useResult
  $Res call({
    String id,
    @JsonKey(unknownEnumValue: MessageDirection.inbound)
    MessageDirection direction,
    String body,
    @JsonKey(unknownEnumValue: MessageStatus.sent) MessageStatus status,
    @JsonKey(unknownEnumValue: MessageType.unknown) MessageType messageType,
    String? mediaUrl,
    String? mediaMimeType,
    String? locationLatitude,
    String? locationLongitude,
    String? locationName,
    String? locationAddress,
    String? transcription,
    String? transcriptionStatus,
    String createdAt,
  });
}

/// @nodoc
class _$MessageCopyWithImpl<$Res, $Val extends Message>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? direction = null,
    Object? body = null,
    Object? status = null,
    Object? messageType = null,
    Object? mediaUrl = freezed,
    Object? mediaMimeType = freezed,
    Object? locationLatitude = freezed,
    Object? locationLongitude = freezed,
    Object? locationName = freezed,
    Object? locationAddress = freezed,
    Object? transcription = freezed,
    Object? transcriptionStatus = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            direction: null == direction
                ? _value.direction
                : direction // ignore: cast_nullable_to_non_nullable
                      as MessageDirection,
            body: null == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as MessageStatus,
            messageType: null == messageType
                ? _value.messageType
                : messageType // ignore: cast_nullable_to_non_nullable
                      as MessageType,
            mediaUrl: freezed == mediaUrl
                ? _value.mediaUrl
                : mediaUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            mediaMimeType: freezed == mediaMimeType
                ? _value.mediaMimeType
                : mediaMimeType // ignore: cast_nullable_to_non_nullable
                      as String?,
            locationLatitude: freezed == locationLatitude
                ? _value.locationLatitude
                : locationLatitude // ignore: cast_nullable_to_non_nullable
                      as String?,
            locationLongitude: freezed == locationLongitude
                ? _value.locationLongitude
                : locationLongitude // ignore: cast_nullable_to_non_nullable
                      as String?,
            locationName: freezed == locationName
                ? _value.locationName
                : locationName // ignore: cast_nullable_to_non_nullable
                      as String?,
            locationAddress: freezed == locationAddress
                ? _value.locationAddress
                : locationAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            transcription: freezed == transcription
                ? _value.transcription
                : transcription // ignore: cast_nullable_to_non_nullable
                      as String?,
            transcriptionStatus: freezed == transcriptionStatus
                ? _value.transcriptionStatus
                : transcriptionStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MessageImplCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$$MessageImplCopyWith(
    _$MessageImpl value,
    $Res Function(_$MessageImpl) then,
  ) = __$$MessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(unknownEnumValue: MessageDirection.inbound)
    MessageDirection direction,
    String body,
    @JsonKey(unknownEnumValue: MessageStatus.sent) MessageStatus status,
    @JsonKey(unknownEnumValue: MessageType.unknown) MessageType messageType,
    String? mediaUrl,
    String? mediaMimeType,
    String? locationLatitude,
    String? locationLongitude,
    String? locationName,
    String? locationAddress,
    String? transcription,
    String? transcriptionStatus,
    String createdAt,
  });
}

/// @nodoc
class __$$MessageImplCopyWithImpl<$Res>
    extends _$MessageCopyWithImpl<$Res, _$MessageImpl>
    implements _$$MessageImplCopyWith<$Res> {
  __$$MessageImplCopyWithImpl(
    _$MessageImpl _value,
    $Res Function(_$MessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? direction = null,
    Object? body = null,
    Object? status = null,
    Object? messageType = null,
    Object? mediaUrl = freezed,
    Object? mediaMimeType = freezed,
    Object? locationLatitude = freezed,
    Object? locationLongitude = freezed,
    Object? locationName = freezed,
    Object? locationAddress = freezed,
    Object? transcription = freezed,
    Object? transcriptionStatus = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$MessageImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        direction: null == direction
            ? _value.direction
            : direction // ignore: cast_nullable_to_non_nullable
                  as MessageDirection,
        body: null == body
            ? _value.body
            : body // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as MessageStatus,
        messageType: null == messageType
            ? _value.messageType
            : messageType // ignore: cast_nullable_to_non_nullable
                  as MessageType,
        mediaUrl: freezed == mediaUrl
            ? _value.mediaUrl
            : mediaUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        mediaMimeType: freezed == mediaMimeType
            ? _value.mediaMimeType
            : mediaMimeType // ignore: cast_nullable_to_non_nullable
                  as String?,
        locationLatitude: freezed == locationLatitude
            ? _value.locationLatitude
            : locationLatitude // ignore: cast_nullable_to_non_nullable
                  as String?,
        locationLongitude: freezed == locationLongitude
            ? _value.locationLongitude
            : locationLongitude // ignore: cast_nullable_to_non_nullable
                  as String?,
        locationName: freezed == locationName
            ? _value.locationName
            : locationName // ignore: cast_nullable_to_non_nullable
                  as String?,
        locationAddress: freezed == locationAddress
            ? _value.locationAddress
            : locationAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        transcription: freezed == transcription
            ? _value.transcription
            : transcription // ignore: cast_nullable_to_non_nullable
                  as String?,
        transcriptionStatus: freezed == transcriptionStatus
            ? _value.transcriptionStatus
            : transcriptionStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageImpl extends _Message {
  const _$MessageImpl({
    required this.id,
    @JsonKey(unknownEnumValue: MessageDirection.inbound)
    required this.direction,
    this.body = '',
    @JsonKey(unknownEnumValue: MessageStatus.sent)
    this.status = MessageStatus.sent,
    @JsonKey(unknownEnumValue: MessageType.unknown)
    this.messageType = MessageType.text,
    this.mediaUrl,
    this.mediaMimeType,
    this.locationLatitude,
    this.locationLongitude,
    this.locationName,
    this.locationAddress,
    this.transcription,
    this.transcriptionStatus,
    required this.createdAt,
  }) : super._();

  factory _$MessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(unknownEnumValue: MessageDirection.inbound)
  final MessageDirection direction;
  @override
  @JsonKey()
  final String body;
  @override
  @JsonKey(unknownEnumValue: MessageStatus.sent)
  final MessageStatus status;
  @override
  @JsonKey(unknownEnumValue: MessageType.unknown)
  final MessageType messageType;
  @override
  final String? mediaUrl;
  @override
  final String? mediaMimeType;
  @override
  final String? locationLatitude;
  @override
  final String? locationLongitude;
  @override
  final String? locationName;
  @override
  final String? locationAddress;
  @override
  final String? transcription;
  @override
  final String? transcriptionStatus;
  @override
  final String createdAt;

  @override
  String toString() {
    return 'Message(id: $id, direction: $direction, body: $body, status: $status, messageType: $messageType, mediaUrl: $mediaUrl, mediaMimeType: $mediaMimeType, locationLatitude: $locationLatitude, locationLongitude: $locationLongitude, locationName: $locationName, locationAddress: $locationAddress, transcription: $transcription, transcriptionStatus: $transcriptionStatus, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.direction, direction) ||
                other.direction == direction) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.messageType, messageType) ||
                other.messageType == messageType) &&
            (identical(other.mediaUrl, mediaUrl) ||
                other.mediaUrl == mediaUrl) &&
            (identical(other.mediaMimeType, mediaMimeType) ||
                other.mediaMimeType == mediaMimeType) &&
            (identical(other.locationLatitude, locationLatitude) ||
                other.locationLatitude == locationLatitude) &&
            (identical(other.locationLongitude, locationLongitude) ||
                other.locationLongitude == locationLongitude) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.locationAddress, locationAddress) ||
                other.locationAddress == locationAddress) &&
            (identical(other.transcription, transcription) ||
                other.transcription == transcription) &&
            (identical(other.transcriptionStatus, transcriptionStatus) ||
                other.transcriptionStatus == transcriptionStatus) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    direction,
    body,
    status,
    messageType,
    mediaUrl,
    mediaMimeType,
    locationLatitude,
    locationLongitude,
    locationName,
    locationAddress,
    transcription,
    transcriptionStatus,
    createdAt,
  );

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      __$$MessageImplCopyWithImpl<_$MessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageImplToJson(this);
  }
}

abstract class _Message extends Message {
  const factory _Message({
    required final String id,
    @JsonKey(unknownEnumValue: MessageDirection.inbound)
    required final MessageDirection direction,
    final String body,
    @JsonKey(unknownEnumValue: MessageStatus.sent) final MessageStatus status,
    @JsonKey(unknownEnumValue: MessageType.unknown)
    final MessageType messageType,
    final String? mediaUrl,
    final String? mediaMimeType,
    final String? locationLatitude,
    final String? locationLongitude,
    final String? locationName,
    final String? locationAddress,
    final String? transcription,
    final String? transcriptionStatus,
    required final String createdAt,
  }) = _$MessageImpl;
  const _Message._() : super._();

  factory _Message.fromJson(Map<String, dynamic> json) = _$MessageImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(unknownEnumValue: MessageDirection.inbound)
  MessageDirection get direction;
  @override
  String get body;
  @override
  @JsonKey(unknownEnumValue: MessageStatus.sent)
  MessageStatus get status;
  @override
  @JsonKey(unknownEnumValue: MessageType.unknown)
  MessageType get messageType;
  @override
  String? get mediaUrl;
  @override
  String? get mediaMimeType;
  @override
  String? get locationLatitude;
  @override
  String? get locationLongitude;
  @override
  String? get locationName;
  @override
  String? get locationAddress;
  @override
  String? get transcription;
  @override
  String? get transcriptionStatus;
  @override
  String get createdAt;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
