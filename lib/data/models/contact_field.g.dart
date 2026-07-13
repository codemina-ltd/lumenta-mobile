// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_field.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ContactField _$ContactFieldFromJson(Map<String, dynamic> json) =>
    _ContactField(
      id: json['id'] as String,
      key: json['key'] as String,
      label: json['label'] as String,
      type: json['type'] as String,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isRequired: json['isRequired'] as bool? ?? false,
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ContactFieldToJson(_ContactField instance) =>
    <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'label': instance.label,
      'type': instance.type,
      'options': instance.options,
      'isRequired': instance.isRequired,
      'displayOrder': instance.displayOrder,
    };

_ContactLifecycleStage _$ContactLifecycleStageFromJson(
  Map<String, dynamic> json,
) => _ContactLifecycleStage(
  id: json['id'] as String,
  key: json['key'] as String,
  label: json['label'] as String,
  color: json['color'] as String? ?? '#B8A4FF',
  displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
  isDefault: json['isDefault'] as bool? ?? false,
);

Map<String, dynamic> _$ContactLifecycleStageToJson(
  _ContactLifecycleStage instance,
) => <String, dynamic>{
  'id': instance.id,
  'key': instance.key,
  'label': instance.label,
  'color': instance.color,
  'displayOrder': instance.displayOrder,
  'isDefault': instance.isDefault,
};
