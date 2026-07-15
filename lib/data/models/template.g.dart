// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Template _$TemplateFromJson(Map<String, dynamic> json) => _Template(
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
  headerMediaUrl: json['headerMediaUrl'] as String?,
  footerText: json['footerText'] as String?,
  buttons: json['buttons'] as List<dynamic>?,
  bodyExample: json['bodyExample'],
  headerExample: json['headerExample'],
  carouselCards: (json['carouselCards'] as List<dynamic>?)
      ?.map((e) => TemplateCarouselCard.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TemplateToJson(_Template instance) => <String, dynamic>{
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
  'headerMediaUrl': instance.headerMediaUrl,
  'footerText': instance.footerText,
  'buttons': instance.buttons,
  'bodyExample': instance.bodyExample,
  'headerExample': instance.headerExample,
  'carouselCards': instance.carouselCards,
};

_TemplateCarouselCard _$TemplateCarouselCardFromJson(
  Map<String, dynamic> json,
) => _TemplateCarouselCard(
  headerFormat: json['headerFormat'] as String? ?? 'IMAGE',
  body: json['body'] as String? ?? '',
  bodyExample: json['bodyExample'],
  buttons: json['buttons'] as List<dynamic>?,
  mediaUrl: json['mediaUrl'] as String?,
);

Map<String, dynamic> _$TemplateCarouselCardToJson(
  _TemplateCarouselCard instance,
) => <String, dynamic>{
  'headerFormat': instance.headerFormat,
  'body': instance.body,
  'bodyExample': instance.bodyExample,
  'buttons': instance.buttons,
  'mediaUrl': instance.mediaUrl,
};
