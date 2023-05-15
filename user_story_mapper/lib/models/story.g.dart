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
      potentialUsers: (json['potentialUsers'] as List<dynamic>?)
          ?.map((e) => PotentialUser.fromJson(e as Map<String, dynamic>))
          .toList(),
      comments: json['comments'] == null
          ? null
          : Comment.fromJson(json['comments'] as Map<String, dynamic>),
      votes: json['votes'] as int?,
    );

Map<String, dynamic> _$StoryToJson(Story instance) => <String, dynamic>{
      'id': instance.id,
      'creatorId': instance.creatorId,
      'description': instance.description,
      'title': instance.title,
      'potentialUsers':
          instance.potentialUsers?.map((e) => e.toJson()).toList(),
      'comments': instance.comments?.toJson(),
      'votes': instance.votes,
    };
