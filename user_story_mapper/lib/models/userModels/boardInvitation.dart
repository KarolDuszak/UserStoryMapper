import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'boardInvitation.g.dart';

@JsonSerializable(explicitToJson: true)
class BoardInvitation {
  BoardInvitation(
      {required this.id,
      required this.message,
      required this.reciever,
      required this.inviterId});

  //Informations
  String id;
  String message;
  String reciever;
  String inviterId;

  factory BoardInvitation.fromJson(Map<String, dynamic> json) =>
      _$BoardInvitationFromJson(json);
  Map<String, dynamic> toJson() => _$BoardInvitationToJson(this);

  static BoardInvitation newInvitation(
      String boardId, String message, String reviever, String inviterId) {
    return BoardInvitation(
        id: boardId,
        message: message,
        reciever: reviever,
        inviterId: inviterId);
  }

  static BoardInvitation getEmptyObj() {
    return BoardInvitation(
        id: "NULL",
        message: "NULL boardInformation",
        reciever: "NULL title",
        inviterId: "NULL inviterId");
  }
}
