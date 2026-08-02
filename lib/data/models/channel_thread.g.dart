// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_thread.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChannelThread _$ChannelThreadFromJson(Map<String, dynamic> json) =>
    _ChannelThread(
      id: json['id'] as String,
      channelType: json['channelType'] as String,
      channelAccountId: json['channelAccountId'] as String,
      serviceWindowExpiresAt: json['serviceWindowExpiresAt'] as String?,
      lastInboundAt: json['lastInboundAt'] as String?,
      lastOutboundAt: json['lastOutboundAt'] as String?,
      accountDisplayName: json['accountDisplayName'] as String?,
      accountStatus: json['accountStatus'] as String? ?? 'inactive',
    );

Map<String, dynamic> _$ChannelThreadToJson(_ChannelThread instance) =>
    <String, dynamic>{
      'id': instance.id,
      'channelType': instance.channelType,
      'channelAccountId': instance.channelAccountId,
      'serviceWindowExpiresAt': instance.serviceWindowExpiresAt,
      'lastInboundAt': instance.lastInboundAt,
      'lastOutboundAt': instance.lastOutboundAt,
      'accountDisplayName': instance.accountDisplayName,
      'accountStatus': instance.accountStatus,
    };
