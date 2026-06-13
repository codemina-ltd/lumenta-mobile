// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbox_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InboxNoteImpl _$$InboxNoteImplFromJson(Map<String, dynamic> json) =>
    _$InboxNoteImpl(
      id: json['id'] as String,
      threadId: json['threadId'] as String,
      authorUserId: json['authorUserId'] as String,
      body: json['body'] as String,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$$InboxNoteImplToJson(_$InboxNoteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'threadId': instance.threadId,
      'authorUserId': instance.authorUserId,
      'body': instance.body,
      'createdAt': instance.createdAt,
    };
