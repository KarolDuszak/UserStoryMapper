// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milestone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Milestone _$MilestoneFromJson(Map<String, dynamic> json) => Milestone(
      id: json['id'] as String,
      description: json['description'] as String,
      title: json['title'] as String,
      epics: (json['epics'] as List<dynamic>)
          .map((e) => Epic.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MilestoneToJson(Milestone instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'title': instance.title,
      'epics': instance.epics.map((e) => e.toJson()).toList(),
    };
