// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_sender.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConversationSender _$ConversationSenderFromJson(Map<String, dynamic> json) =>
    _ConversationSender(
      senderId: json['senderId'] as String,
      displayName: json['displayName'] as String?,
      displayPhoneNumber: json['displayPhoneNumber'] as String?,
      senderStatus:
          $enumDecodeNullable(
            _$SenderStatusEnumMap,
            json['senderStatus'],
            unknownValue: SenderStatus.pending,
          ) ??
          SenderStatus.pending,
      isDefault: json['isDefault'] as bool? ?? false,
      messageCount: (json['messageCount'] as num?)?.toInt() ?? 0,
      lastMessageAt: json['lastMessageAt'] as String?,
      lastMessageDirection: $enumDecodeNullable(
        _$MessageDirectionEnumMap,
        json['lastMessageDirection'],
        unknownValue: MessageDirection.inbound,
      ),
    );

Map<String, dynamic> _$ConversationSenderToJson(_ConversationSender instance) =>
    <String, dynamic>{
      'senderId': instance.senderId,
      'displayName': instance.displayName,
      'displayPhoneNumber': instance.displayPhoneNumber,
      'senderStatus': _$SenderStatusEnumMap[instance.senderStatus]!,
      'isDefault': instance.isDefault,
      'messageCount': instance.messageCount,
      'lastMessageAt': instance.lastMessageAt,
      'lastMessageDirection':
          _$MessageDirectionEnumMap[instance.lastMessageDirection],
    };

const _$SenderStatusEnumMap = {
  SenderStatus.pending: 'pending',
  SenderStatus.active: 'active',
  SenderStatus.inactive: 'inactive',
  SenderStatus.error: 'error',
};

const _$MessageDirectionEnumMap = {
  MessageDirection.inbound: 'inbound',
  MessageDirection.outbound: 'outbound',
};
