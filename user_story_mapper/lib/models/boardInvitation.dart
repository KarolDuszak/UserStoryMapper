import 'package:json_annotation/json_annotation.dart';
import 'package:user_story_mapper/models/potentialUser.dart';
import 'package:user_story_mapper/models/epic.dart';
import 'dart:convert';

@JsonSerializable(explicitToJson: true)
class BoardInvitation {
  BoardInvitation(
      {required this.id,
      required this.boardInformation,
      required this.userId,
      required this.inviterId});

  //Informations
   String id;
   String boardInformation;
   String userId;
   String inviterId;

  static BoardInvitation getEmptyObj() {
    return BoardInvitation(
        id: "NULL",
        boardInformation: "NULL boardInformation",
        userId: "NULL title",
        inviterId: "NULL inviterId");
  }
}
