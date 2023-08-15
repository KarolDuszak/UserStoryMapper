import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:uuid/uuid.dart';

part 'story.g.dart';

@JsonSerializable(explicitToJson: true)
class Story extends Equatable {
  Story(
      {required this.id,
      required this.creatorId,
      required this.description,
      required this.title,
      required this.potentialUsers,
      required this.votes});

  //Informations
  final String id;
  final String creatorId;
  final String description;
  final String title;
  //Interaction
  final List<String> potentialUsers;
  final int? votes;

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
  Map<String, dynamic> toJson() => _$StoryToJson(this);

  @override
  List<Object?> get props =>
      [id, creatorId, description, title, potentialUsers, votes];

  static Story getEmptyObj(String num, List<String> potUsers) {
    var uuid = Uuid().v1();
    return Story(
        id: uuid,
        creatorId: "NULL creatorId",
        description: "NULL description",
        title: "${num} Very long title sadasdasda sadasdasdasd asdasdasdasd ",
        potentialUsers: potUsers,
        votes: 4);
  }

  static Story createStory(
      String title, String description, List<String> potUsers) {
    var uuid = Uuid().v1();
    return Story(
        id: uuid,
        creatorId: "NULL creatorId",
        description: description,
        title: title,
        potentialUsers: potUsers,
        votes: 0);
  }

  static Story getEmptyObj2() {
    var uuid = Uuid().v1();
    return Story(
        id: uuid,
        creatorId: "NULL creatorId",
        description: "NULL description",
        title: "${uuid} short title",
        potentialUsers: [],
        votes: 4);
  }
}
