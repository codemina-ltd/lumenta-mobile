// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TemplateImpl _$$TemplateImplFromJson(Map<String, dynamic> json) =>
    _$TemplateImpl(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      language: json['language'] as String? ?? '',
      status: json['status'] as String? ?? '',
      parameterFormat: json['parameterFormat'] as String? ?? 'positional',
      body: json['body'] as String? ?? '',
      variables: (json['variables'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      headerFormat: json['headerFormat'] as String?,
      headerText: json['headerText'] as String?,
      headerS3Key: json['headerS3Key'] as String?,
      footerText: json['footerText'] as String?,
      buttons: json['buttons'] as List<dynamic>?,
      bodyExample: json['bodyExample'],
      headerExample: json['headerExample'],
    );

Map<String, dynamic> _$$TemplateImplToJson(_$TemplateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'language': instance.language,
      'status': instance.status,
      'parameterFormat': instance.parameterFormat,
      'body': instance.body,
      'variables': instance.variables,
      'headerFormat': instance.headerFormat,
      'headerText': instance.headerText,
      'headerS3Key': instance.headerS3Key,
      'footerText': instance.footerText,
      'buttons': instance.buttons,
      'bodyExample': instance.bodyExample,
      'headerExample': instance.headerExample,
    };
