import 'package:json_annotation/json_annotation.dart';
import 'package:user_story_mapper/models/potentialUser.dart';
import 'package:user_story_mapper/models/milestone.dart';
import 'package:user_story_mapper/models/roleLabel.dart';
import 'package:user_story_mapper/models/member.dart';
import 'package:uuid/uuid.dart';

part 'board.g.dart';

@JsonSerializable(explicitToJson: true)
class Board {
  Board(
      {required this.id,
      required this.creatorId,
      required this.description,
      required this.title,
      required this.potentialUsers,
      required this.milestones,
      required this.roleLabels,
      required this.members,
      required this.votesNumber,
      required this.timer});

  //Informations
  String id;
  String creatorId;
  List<String> roles =
      List<String>.from(<String>["Owner", "Member", "Visitor"]);
  String? description;
  String? title;
  //Interaction
  List<PotentialUser>? potentialUsers;
  List<Milestone> milestones;
  List<RoleLabel>? roleLabels;
  List<Member>? members;
  int? votesNumber;
  String? timer; //Not sure how to implement jet

  factory Board.fromJson(Map<String, dynamic> json) => _$BoardFromJson(json);
  Map<String, dynamic> toJson() => _$BoardToJson(this);

  static Board getEmptyObj(int num) {
    return Board(
      id: Uuid().v4(),
      creatorId: "NULL creatorId",
      description: "NULL description",
      title: "NULL title",
      potentialUsers:
          List<PotentialUser>.filled(3, PotentialUser.getEmptyObj()),
      milestones:
          List.generate(2, (innerIndex) => Milestone.getEmptyObj(innerIndex)),
      roleLabels: List<RoleLabel>.filled(2, RoleLabel.getEmptyObj()),
      members: List<Member>.filled(2, Member.getEmptyObj()),
      votesNumber: 5,
      timer: "NULL timer",
    );
  }
}
