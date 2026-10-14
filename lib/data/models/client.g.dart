// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Client _$ClientFromJson(Map<String, dynamic> json) => _Client(
  id: json['id'] as String,
  phoneNumber: json['phoneNumber'] as String?,
  profileName: json['profileName'] as String?,
  workspaceName: json['displayName'] as String?,
  name: json['name'] as String?,
  createdAt: json['createdAt'] as String?,
);

Map<String, dynamic> _$ClientToJson(_Client instance) => <String, dynamic>{
  'id': instance.id,
  'phoneNumber': instance.phoneNumber,
  'profileName': instance.profileName,
  'displayName': instance.workspaceName,
  'name': instance.name,
  'createdAt': instance.createdAt,
};
