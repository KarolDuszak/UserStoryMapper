import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_story_mapper/models/boardModels/potentialUser.dart';
import 'package:user_story_mapper/models/boardModels/milestone.dart';
import 'package:user_story_mapper/models/boardModels/member.dart';
import 'package:uuid/uuid.dart';

import '../../utils/utils.dart';

part 'board.g.dart';

@JsonSerializable(explicitToJson: true)
class Board extends Equatable {
  Board(
      {required this.id,
      required this.creatorId,
      required this.description,
      required this.title,
      required this.potentialUsers,
      required this.milestones,
      required this.members,
      required this.votesNumber,
      required this.timer});

  //Informations
  final String id;
  final String creatorId;
  final List<String> roles =
      List<String>.from(<String>["Admin", "Member", "Visitor"]);
  final String description;
  final String title;
  //Interaction
  final List<PotentialUser> potentialUsers;
  final List<Milestone> milestones;
  final List<Member> members;
  final int? votesNumber;
  final DateTime? timer;

  factory Board.fromJson(Map<String, dynamic> json) => _$BoardFromJson(json);
  Map<String, dynamic> toJson() => _$BoardToJson(this);

  @override
  List<Object?> get props => [
        id,
        creatorId,
        description,
        title,
        potentialUsers,
        milestones,
        members,
        votesNumber,
        timer
      ];

  static Board addNewBoard(String creatorId, String title, String description) {
    return Board(
      id: Uuid().v4(),
      creatorId: creatorId,
      title: title,
      description: description,
      milestones: [Milestone.createMvpMilestone()],
      potentialUsers: [],
      members: [
        Member(
            id: creatorId,
            role: 'Admin',
            name: "Owner",
            votesUsed: 0,
            invitationAccepted: true)
      ],
      votesNumber: 5,
      timer: DateTime.now(),
    );
  }
}
