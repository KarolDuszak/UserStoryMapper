// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Member _$MemberFromJson(Map<String, dynamic> json) => Member(
      id: json['id'] as String,
      role: json['role'] as String,
      voterRemaining: json['voterRemaining'] as int?,
      roleLabel: json['roleLabel'] == null
          ? null
          : RoleLabel.fromJson(json['roleLabel'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
      'id': instance.id,
      'role': instance.role,
      'voterRemaining': instance.voterRemaining,
      'roleLabel': instance.roleLabel?.toJson(),
    };
