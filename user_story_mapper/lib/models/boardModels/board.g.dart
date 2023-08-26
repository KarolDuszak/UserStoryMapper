// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Board _$BoardFromJson(Map<String, dynamic> json) => Board(
      id: json['id'] as String,
      creatorId: json['creatorId'] as String,
      description: json['description'] as String,
      title: json['title'] as String,
      potentialUsers: (json['potentialUsers'] as List<dynamic>)
          .map((e) => PotentialUser.fromJson(e as Map<String, dynamic>))
          .toList(),
      milestones: (json['milestones'] as List<dynamic>)
          .map((e) => Milestone.fromJson(e as Map<String, dynamic>))
          .toList(),
      members: Util.decodeMapToMebmers(json['members']),
      votesNumber: json['votesNumber'] as int?,
      timer: json['timer'] == null
          ? null
          : DateTime.parse(json['timer'] as String),
    );

Map<String, dynamic> _$BoardToJson(Board instance) => <String, dynamic>{
      'id': instance.id,
      'creatorId': instance.creatorId,
      'description': instance.description,
      'title': instance.title,
      'potentialUsers': instance.potentialUsers.map((e) => e.toJson()).toList(),
      'milestones': instance.milestones.map((e) => e.toJson()).toList(),
      'members': Util.encodeMembersToMap(instance.members),
      'votesNumber': instance.votesNumber,
      'timer': instance.timer?.toIso8601String(),
    };
