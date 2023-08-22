// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boardInvitation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoardInvitation _$BoardInvitationFromJson(Map<String, dynamic> json) =>
    BoardInvitation(
      id: json['id'] as String,
      message: json['message'] as String,
      reciever: json['reciever'] as String,
      inviterId: json['inviterId'] as String,
    );

Map<String, dynamic> _$BoardInvitationToJson(BoardInvitation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'reciever': instance.reciever,
      'inviterId': instance.inviterId,
    };
