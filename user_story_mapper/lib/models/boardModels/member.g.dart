// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Member _$MemberFromJson(Map<String, dynamic> json) => Member(
    id: json['id'] as String,
    role: json['role'] as String,
    name: json['name'] as String,
    votesUsed: json['votesUsed'] as int?,
    invitationAccepted: json['invitationAccepted'] as bool);

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
      'id': instance.id,
      'role': instance.role,
      'name': instance.name,
      'votesUsed': instance.votesUsed,
      'invitationAccepted': instance.invitationAccepted
    };
