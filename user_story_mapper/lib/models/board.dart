import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_story_mapper/models/potentialUser.dart';
import 'package:user_story_mapper/models/milestone.dart';
import 'package:user_story_mapper/models/roleLabel.dart';
import 'package:user_story_mapper/models/member.dart';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';

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
      required this.roleLabels,
      required this.members,
      required this.votesNumber,
      required this.timer});

  //Informations
  final String id;
  final String creatorId;
  final List<String> roles =
      List<String>.from(<String>["Owner", "Member", "Visitor"]);
  final String? description;
  final String? title;
  //Interaction
  final List<PotentialUser>? potentialUsers;
  final List<Milestone> milestones;
  final List<RoleLabel>? roleLabels;
  final List<Member>? members;
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
        roleLabels,
        members,
        votesNumber,
        timer
      ];

  static Board getEmptyObj(int num) {
    return Board(
      id: "Test",
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
      timer: DateTime.now(),
    );
  }

  static Board addNewBoard(String creatorId, String title, String description) {
    return Board(
      id: Uuid().v4(),
      creatorId: creatorId,
      title: title,
      description: description,
      milestones: [],
      potentialUsers: [],
      roleLabels: [],
      members: [],
      votesNumber: 5,
      timer: DateTime.now(),
    );
  }
}
