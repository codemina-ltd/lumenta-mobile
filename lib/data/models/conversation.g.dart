// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Conversation _$ConversationFromJson(Map<String, dynamic> json) =>
    _Conversation(
      clientId: _clientId(json, 'clientId') as String,
      phoneNumber: json['phoneNumber'] as String,
      profileName: json['profileName'] as String?,
      lastMessageBody: json['lastMessageBody'] as String?,
      lastMessageType: $enumDecodeNullable(
        _$MessageTypeEnumMap,
        json['lastMessageType'],
        unknownValue: MessageType.text,
      ),
      lastMessageDirection: $enumDecodeNullable(
        _$MessageDirectionEnumMap,
        json['lastMessageDirection'],
        unknownValue: MessageDirection.inbound,
      ),
      lastMessageAt: json['lastMessageAt'] as String?,
    );

Map<String, dynamic> _$ConversationToJson(_Conversation instance) =>
    <String, dynamic>{
      'clientId': instance.clientId,
      'phoneNumber': instance.phoneNumber,
      'profileName': instance.profileName,
      'lastMessageBody': instance.lastMessageBody,
      'lastMessageType': _$MessageTypeEnumMap[instance.lastMessageType],
      'lastMessageDirection':
          _$MessageDirectionEnumMap[instance.lastMessageDirection],
      'lastMessageAt': instance.lastMessageAt,
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
  MessageType.order: 'order',
  MessageType.unknown: 'unknown',
};

const _$MessageDirectionEnumMap = {
  MessageDirection.inbound: 'inbound',
  MessageDirection.outbound: 'outbound',
};
