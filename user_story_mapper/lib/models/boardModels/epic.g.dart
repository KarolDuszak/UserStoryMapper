// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Epic _$EpicFromJson(Map<String, dynamic> json) => Epic(
      id: json['id'] as String,
      description: json['description'] as String,
      title: json['title'] as String,
      features: Util.decodeMapToMatrixOfStories(json['features']),
      potentialUsers:
          (json['potentialUsers'] as List<dynamic>).map((e) => e.toString()).toList(),
      votes: (json['votes'] as List<dynamic>).map((e) => e.toString()).toList(),
    );

Map<String, dynamic> _$EpicToJson(Epic instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'title': instance.title,
      'features': Util.encodeMatrixOfStoriesToMap(instance.features),
      'potentialUsers': instance.potentialUsers.map((e) => e).toList(),
      'votes': instance.votes.map((e) => e).toList(),
    };
