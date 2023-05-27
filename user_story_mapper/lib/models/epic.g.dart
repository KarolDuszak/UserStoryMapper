// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Epic _$EpicFromJson(Map<String, dynamic> json) => Epic(
      id: json['id'] as String,
      description: json['description'] as String,
      title: json['title'] as String,
      features: (json['features'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
              .map((e) => Story.fromJson(e as Map<String, dynamic>))
              .toList())
          .toList(),
      potentialUsers: (json['potentialUsers'] as List<dynamic>?)
          ?.map((e) => PotentialUser.fromJson(e as Map<String, dynamic>))
          .toList(),
      votes: json['votes'] as int?,
    );

Map<String, dynamic> _$EpicToJson(Epic instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'title': instance.title,
      'features': instance.features.map((e) => e[0].toJson()).toList(),
      //{
      //  'map1': {
      //    'key1': ['value1', 'value3'],
      //    'key2': ['value2', 'value4'],
      //  }
      //},

      //instance.features
      //    .map((e) => e.map((e) => e.toJson()).toList())
      //    .toList(),
      'potentialUsers':
          instance.potentialUsers?.map((e) => e.toJson()).toList(),
      'votes': instance.votes,
    };
