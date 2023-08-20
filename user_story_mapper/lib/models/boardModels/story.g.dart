// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Story _$StoryFromJson(Map<String, dynamic> json) => Story(
      id: json['id'] as String,
      creatorId: json['creatorId'] as String,
      description: json['description'] as String,
      title: json['title'] as String,
      potentialUsers: (json['potentialUsers'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      votes: (json['votes'] as List<dynamic>).map((e) => e.toString()).toList(),
    );

Map<String, dynamic> _$StoryToJson(Story instance) => <String, dynamic>{
      'id': instance.id,
      'creatorId': instance.creatorId,
      'description': instance.description,
      'title': instance.title,
      'potentialUsers': instance.potentialUsers.map((e) => e).toList(),
      'votes': instance.votes.map((e) => e).toList(),
    };
