// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['id'] as String,
      creatorId: json['creatorId'] as String,
      storyId: json['storyId'] as String,
      content: json['content'] as String,
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'creatorId': instance.creatorId,
      'storyId': instance.storyId,
      'content': instance.content,
      'date': instance.date.toIso8601String(),
    };
