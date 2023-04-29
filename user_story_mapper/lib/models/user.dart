import 'package:json_annotation/json_annotation.dart';
import 'package:user_story_mapper/models/board.dart';
import 'package:user_story_mapper/models/boardInvitation.dart';
import 'dart:convert';

@JsonSerializable(explicitToJson: true)
class User {
  User(
      {required this.id,
      required this.email,
      required this.name,
      required this.password,
      required this.invitationsToBoard,
      required this.boards});

  //Informations
   String id;
  String email;
  String name;
  String password;
  List<BoardInvitation> invitationsToBoard;
  List<Board> boards;

  static User getEmptyObj(int num) {
    return User(
        id: "NULL",
        email: "NULL email",
        name: "NULL email",
        password: "NULL password",
        invitationsToBoard:
            List<BoardInvitation>.filled(2, BoardInvitation.getEmptyObj()),
        boards: List<Board>.filled(3, Board.getEmptyObj(num)));
  }
}
