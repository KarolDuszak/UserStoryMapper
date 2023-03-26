import 'package:json_annotation/json_annotation.dart';
import 'package:user_story_mapper/models/potentialUser.dart';
import 'dart:convert';
import 'comment.dart';

@JsonSerializable(explicitToJson: true)
class Story {
  Story(
      {required this.id,
      required this.creatorId,
      required this.description,
      required this.title,
      required this.potentialUser,
      required this.comments,
      required this.votes});

  //Informations
  final String id;
  final String creatorId;
  final String description;
  final String title;
  //Interaction
  final PotentialUser potentialUser;
  final Comment comments;
  final int votes;

  static Story getEmptyStoryObj() {
    return Story(
        id: "NULL",
        creatorId: "NULL creatorId",
        description: "NULL description",
        title: "NULL title",
        potentialUser: PotentialUser.getEmptyPotentialUserObj(),
        comments: Comment.getEmptyCommentObj(),
        votes: 0);
  }
}
