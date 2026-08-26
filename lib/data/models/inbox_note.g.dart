// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbox_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InboxNote _$InboxNoteFromJson(Map<String, dynamic> json) => _InboxNote(
  id: json['id'] as String,
  threadId: json['threadId'] as String,
  authorUserId: json['authorUserId'] as String,
  body: json['body'] as String,
  createdAt: json['createdAt'] as String?,
  reactions:
      (json['reactions'] as List<dynamic>?)
          ?.map((e) => InboxNoteReaction.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <InboxNoteReaction>[],
);

Map<String, dynamic> _$InboxNoteToJson(_InboxNote instance) =>
    <String, dynamic>{
      'id': instance.id,
      'threadId': instance.threadId,
      'authorUserId': instance.authorUserId,
      'body': instance.body,
      'createdAt': instance.createdAt,
      'reactions': instance.reactions,
    };

_InboxNoteReaction _$InboxNoteReactionFromJson(Map<String, dynamic> json) =>
    _InboxNoteReaction(
      emoji: json['emoji'] as String,
      count: (json['count'] as num?)?.toInt() ?? 0,
      userIds:
          (json['userIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      reactedByMe: json['reactedByMe'] as bool? ?? false,
    );

Map<String, dynamic> _$InboxNoteReactionToJson(_InboxNoteReaction instance) =>
    <String, dynamic>{
      'emoji': instance.emoji,
      'count': instance.count,
      'userIds': instance.userIds,
      'reactedByMe': instance.reactedByMe,
    };
