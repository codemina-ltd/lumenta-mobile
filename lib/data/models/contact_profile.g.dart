// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContactProfileImpl _$$ContactProfileImplFromJson(Map<String, dynamic> json) =>
    _$ContactProfileImpl(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      lifecycleStageId: json['lifecycleStageId'] as String?,
      source: json['source'] as String?,
      displayName: json['displayName'] as String?,
      locale: json['locale'] as String?,
      optInMarketing: json['optInMarketing'] as bool? ?? false,
      optInAt: json['optInAt'] as String?,
      firstContactedAt: json['firstContactedAt'] as String?,
      lastContactedAt: json['lastContactedAt'] as String?,
    );

Map<String, dynamic> _$$ContactProfileImplToJson(
  _$ContactProfileImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'clientId': instance.clientId,
  'lifecycleStageId': instance.lifecycleStageId,
  'source': instance.source,
  'displayName': instance.displayName,
  'locale': instance.locale,
  'optInMarketing': instance.optInMarketing,
  'optInAt': instance.optInAt,
  'firstContactedAt': instance.firstContactedAt,
  'lastContactedAt': instance.lastContactedAt,
};

_$ContactProfileResponseImpl _$$ContactProfileResponseImplFromJson(
  Map<String, dynamic> json,
) => _$ContactProfileResponseImpl(
  profile: json['profile'] == null
      ? null
      : ContactProfile.fromJson(json['profile'] as Map<String, dynamic>),
  fieldValues:
      (json['fieldValues'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
);

Map<String, dynamic> _$$ContactProfileResponseImplToJson(
  _$ContactProfileResponseImpl instance,
) => <String, dynamic>{
  'profile': instance.profile,
  'fieldValues': instance.fieldValues,
};
