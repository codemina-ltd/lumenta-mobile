// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageImpl _$$MessageImplFromJson(Map<String, dynamic> json) =>
    _$MessageImpl(
      id: json['id'] as String,
      direction: $enumDecode(
        _$MessageDirectionEnumMap,
        json['direction'],
        unknownValue: MessageDirection.inbound,
      ),
      body: json['body'] as String? ?? '',
      status:
          $enumDecodeNullable(
            _$MessageStatusEnumMap,
            json['status'],
            unknownValue: MessageStatus.sent,
          ) ??
          MessageStatus.sent,
      messageType:
          $enumDecodeNullable(
            _$MessageTypeEnumMap,
            json['messageType'],
            unknownValue: MessageType.unknown,
          ) ??
          MessageType.text,
      mediaUrl: json['mediaUrl'] as String?,
      mediaMimeType: json['mediaMimeType'] as String?,
      locationLatitude: json['locationLatitude'] as String?,
      locationLongitude: json['locationLongitude'] as String?,
      locationName: json['locationName'] as String?,
      locationAddress: json['locationAddress'] as String?,
      transcription: json['transcription'] as String?,
      transcriptionStatus: json['transcriptionStatus'] as String?,
      providerRawPayload: json['providerRawPayload'] as Map<String, dynamic>?,
      senderId: json['senderId'] as String?,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$$MessageImplToJson(_$MessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'direction': _$MessageDirectionEnumMap[instance.direction]!,
      'body': instance.body,
      'status': _$MessageStatusEnumMap[instance.status]!,
      'messageType': _$MessageTypeEnumMap[instance.messageType]!,
      'mediaUrl': instance.mediaUrl,
      'mediaMimeType': instance.mediaMimeType,
      'locationLatitude': instance.locationLatitude,
      'locationLongitude': instance.locationLongitude,
      'locationName': instance.locationName,
      'locationAddress': instance.locationAddress,
      'transcription': instance.transcription,
      'transcriptionStatus': instance.transcriptionStatus,
      'providerRawPayload': instance.providerRawPayload,
      'senderId': instance.senderId,
      'createdAt': instance.createdAt,
    };

const _$MessageDirectionEnumMap = {
  MessageDirection.inbound: 'inbound',
  MessageDirection.outbound: 'outbound',
};

const _$MessageStatusEnumMap = {
  MessageStatus.sent: 'sent',
  MessageStatus.delivered: 'delivered',
  MessageStatus.read: 'read',
  MessageStatus.failed: 'failed',
  MessageStatus.received: 'received',
};

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.image: 'image',
  MessageType.video: 'video',
  MessageType.audio: 'audio',
  MessageType.document: 'document',
  MessageType.sticker: 'sticker',
  MessageType.location: 'location',
  MessageType.contacts: 'contacts',
  MessageType.button: 'button',
  MessageType.interactive: 'interactive',
  MessageType.template: 'template',
  MessageType.reaction: 'reaction',
  MessageType.unknown: 'unknown',
};
