import 'package:json_annotation/json_annotation.dart';

part 'boardInvitation.g.dart';

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

  factory BoardInvitation.fromJson(Map<String, dynamic> json) =>
      _$BoardInvitationFromJson(json);
  Map<String, dynamic> toJson() => _$BoardInvitationToJson(this);

  static BoardInvitation getEmptyObj() {
    return BoardInvitation(
        id: "NULL",
        boardInformation: "NULL boardInformation",
        userId: "NULL title",
        inviterId: "NULL inviterId");
  }
}
