import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_story_mapper/models/board.dart';
import 'package:user_story_mapper/models/boardInvitation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User extends Equatable {
  User(
      {required this.id,
      required this.email,
      required this.name,
      required this.password,
      required this.invitationsToBoard,
      required this.boards});

  //Informations
  final String id;
  final String email;
  final String name;
  final String password;
  final List<BoardInvitation> invitationsToBoard;
  final List<Board> boards;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props =>
      [id, email, name, password, invitationsToBoard, boards];

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
