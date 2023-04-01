import 'package:json_annotation/json_annotation.dart';
import 'package:user_story_mapper/models/potentialUser.dart';
import 'package:user_story_mapper/models/comment.dart';
import 'dart:convert';

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
  final String id;
  final String creatorId;
  String description;
  String title;
  //Interaction
  List<PotentialUser>? potentialUsers;
  Comment? comments;
  int? votes;

  static Story getEmptyObj() {
    return Story(
        id: "NULL",
        creatorId: "NULL creatorId",
        description: "NULL description",
        title: "NULL title",
        potentialUsers: List<PotentialUser>.filled(
            2, PotentialUser.getEmptyObj()),
        comments: Comment.getEmptyCommentObj(),
        votes: 0);
  }
}
