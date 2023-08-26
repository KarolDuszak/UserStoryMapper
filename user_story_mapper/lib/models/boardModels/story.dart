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
  final List<String> votes;

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
  Map<String, dynamic> toJson() => _$StoryToJson(this);

  @override
  List<Object?> get props =>
      [id, creatorId, description, title, potentialUsers, votes];

  static Story createStory(String title, String description,
      List<String> potUsers, String creatorId) {
    var uuid = Uuid().v1();
    return Story(
        id: uuid,
        creatorId: creatorId,
        description: description,
        title: title,
        potentialUsers: potUsers,
        votes: []);
  }

  static Story assignVotes(Story story, List<String> votes) {
    return Story(
        id: story.id,
        creatorId: story.creatorId,
        description: story.description,
        title: story.title,
        potentialUsers: story.potentialUsers,
        votes: votes);
  }
}
