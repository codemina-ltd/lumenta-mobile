// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smp_call.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SmpCall _$SmpCallFromJson(Map<String, dynamic> json) => _SmpCall(
  id: json['id'] as String,
  startedAt: json['startedAt'] as String,
  direction: $enumDecode(
    _$CallDirectionEnumMap,
    json['direction'],
    unknownValue: CallDirection.unknown,
  ),
  durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
  deviceIdentifier: json['deviceIdentifier'] as String?,
  clientNumber: json['clientNumber'] as String,
  smpEmployeeName: json['smpEmployeeName'] as String?,
  agentUserId: json['agentUserId'] as String?,
  agentName: json['agentName'] as String?,
);

Map<String, dynamic> _$SmpCallToJson(_SmpCall instance) => <String, dynamic>{
  'id': instance.id,
  'startedAt': instance.startedAt,
  'direction': _$CallDirectionEnumMap[instance.direction]!,
  'durationSeconds': instance.durationSeconds,
  'deviceIdentifier': instance.deviceIdentifier,
  'clientNumber': instance.clientNumber,
  'smpEmployeeName': instance.smpEmployeeName,
  'agentUserId': instance.agentUserId,
  'agentName': instance.agentName,
};

const _$CallDirectionEnumMap = {
  CallDirection.incoming: 'incoming',
  CallDirection.outgoing: 'outgoing',
  CallDirection.missed: 'missed',
  CallDirection.rejected: 'rejected',
  CallDirection.unknown: 'unknown',
};
