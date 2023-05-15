// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      password: json['password'] as String,
      invitationsToBoard: (json['invitationsToBoard'] as List<dynamic>)
          .map((e) => BoardInvitation.fromJson(e as Map<String, dynamic>))
          .toList(),
      boards: (json['boards'] as List<dynamic>)
          .map((e) => Board.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'password': instance.password,
      'invitationsToBoard':
          instance.invitationsToBoard.map((e) => e.toJson()).toList(),
      'boards': instance.boards.map((e) => e.toJson()).toList(),
    };
