// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ClientSearchMatch _$ClientSearchMatchFromJson(Map<String, dynamic> json) =>
    _ClientSearchMatch(
      source: json['source'] as String,
      snippet: json['snippet'] as String,
      fieldLabel: json['fieldLabel'] as String?,
    );

Map<String, dynamic> _$ClientSearchMatchToJson(_ClientSearchMatch instance) =>
    <String, dynamic>{
      'source': instance.source,
      'snippet': instance.snippet,
      'fieldLabel': instance.fieldLabel,
    };

_ClientSearchResult _$ClientSearchResultFromJson(Map<String, dynamic> json) =>
    _ClientSearchResult(
      client: Client.fromJson(json['client'] as Map<String, dynamic>),
      score: (json['score'] as num).toInt(),
      matches: (json['matches'] as List<dynamic>)
          .map((e) => ClientSearchMatch.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ClientSearchResultToJson(_ClientSearchResult instance) =>
    <String, dynamic>{
      'client': instance.client,
      'score': instance.score,
      'matches': instance.matches,
    };
