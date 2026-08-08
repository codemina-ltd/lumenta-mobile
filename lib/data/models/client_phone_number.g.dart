// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_phone_number.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ClientPhoneNumber _$ClientPhoneNumberFromJson(Map<String, dynamic> json) =>
    _ClientPhoneNumber(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      phoneNumber: json['phoneNumber'] as String,
      isPrimary: json['isPrimary'] as bool? ?? false,
      label: json['label'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$ClientPhoneNumberToJson(_ClientPhoneNumber instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'phoneNumber': instance.phoneNumber,
      'isPrimary': instance.isPrimary,
      'label': instance.label,
      'createdAt': instance.createdAt,
    };
