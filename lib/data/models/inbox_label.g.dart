// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbox_label.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InboxLabel _$InboxLabelFromJson(Map<String, dynamic> json) => _InboxLabel(
  id: json['id'] as String,
  name: json['name'] as String,
  color: json['color'] as String? ?? '#00C896',
);

Map<String, dynamic> _$InboxLabelToJson(_InboxLabel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'color': instance.color,
    };
