// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sender.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Sender _$SenderFromJson(Map<String, dynamic> json) => _Sender(
  id: json['id'] as String,
  displayName: json['displayName'] as String? ?? '',
  phoneNumber: json['phoneNumber'] as String?,
  displayPhoneNumber: json['displayPhoneNumber'] as String?,
  status:
      $enumDecodeNullable(
        _$SenderStatusEnumMap,
        json['status'],
        unknownValue: SenderStatus.pending,
      ) ??
      SenderStatus.pending,
  isDefault: json['isDefault'] as bool? ?? false,
);

Map<String, dynamic> _$SenderToJson(_Sender instance) => <String, dynamic>{
  'id': instance.id,
  'displayName': instance.displayName,
  'phoneNumber': instance.phoneNumber,
  'displayPhoneNumber': instance.displayPhoneNumber,
  'status': _$SenderStatusEnumMap[instance.status]!,
  'isDefault': instance.isDefault,
};

const _$SenderStatusEnumMap = {
  SenderStatus.pending: 'pending',
  SenderStatus.active: 'active',
  SenderStatus.inactive: 'inactive',
  SenderStatus.error: 'error',
};
