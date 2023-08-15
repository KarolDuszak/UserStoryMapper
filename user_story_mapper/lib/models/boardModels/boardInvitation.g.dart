// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boardInvitation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoardInvitation _$BoardInvitationFromJson(Map<String, dynamic> json) =>
    BoardInvitation(
      id: json['id'] as String,
      boardInformation: json['boardInformation'] as String,
      userId: json['userId'] as String,
      inviterId: json['inviterId'] as String,
    );

Map<String, dynamic> _$BoardInvitationToJson(BoardInvitation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'boardInformation': instance.boardInformation,
      'userId': instance.userId,
      'inviterId': instance.inviterId,
    };
