// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  id: json['id'] as String,
  email: json['email'] as String?,
  name: json['name'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  profileName: json['profileName'] as String?,
  locale: json['locale'] as String?,
  timezone: json['timezone'] as String?,
  font: json['font'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  pendingEmail: json['pendingEmail'] as String?,
  createdAt: json['createdAt'] as String?,
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'profileName': instance.profileName,
      'locale': instance.locale,
      'timezone': instance.timezone,
      'font': instance.font,
      'avatarUrl': instance.avatarUrl,
      'pendingEmail': instance.pendingEmail,
      'createdAt': instance.createdAt,
    };
