import 'package:json_annotation/json_annotation.dart';
import 'package:user_story_mapper/models/potentialUser.dart';
import 'package:user_story_mapper/models/comment.dart';
import 'dart:convert';

import 'package:uuid/uuid.dart';

@JsonSerializable(explicitToJson: true)
class Story {
  Story(
      {required this.id,
      required this.creatorId,
      required this.description,
      required this.title,
      required this.potentialUsers,
      required this.comments,
      required this.votes});

  //Informations
  String id;
  String creatorId;
  String description;
  String title;
  //Interaction
  List<PotentialUser>? potentialUsers;
  Comment? comments;
  int? votes;

  static Story getEmptyObj(String num) {
    var uuid = Uuid().v1();
    return Story(
        id: uuid,
        creatorId: "NULL creatorId",
        description: "NULL description",
        title: "${num} Very long title sadasdasda sadasdasdasd asdasdasdasd ",
        potentialUsers:
            List<PotentialUser>.filled(6, PotentialUser.getEmptyObj()),
        comments: Comment.getEmptyCommentObj(),
        votes: 4);
  }

  static Story getEmptyObj2() {
    var uuid = Uuid().v1();
    return Story(
        id: uuid,
        creatorId: "NULL creatorId",
        description: "NULL description",
        title: "${uuid} short title",
        potentialUsers:
            List<PotentialUser>.filled(3, PotentialUser.getEmptyObj()),
        comments: Comment.getEmptyCommentObj(),
        votes: 4);
  }
}
