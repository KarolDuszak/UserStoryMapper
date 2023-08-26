import 'package:equatable/equatable.dart';
import 'package:user_story_mapper/utils/utils.dart';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_story_mapper/models/boardModels/story.dart';

part 'epic.g.dart';

@JsonSerializable(explicitToJson: true)
class Epic extends Equatable {
  Epic(
      {required this.id,
      required this.description,
      required this.title,
      this.features,
      required this.potentialUsers,
      required this.votes});

  //Informations
  final String id;
  final String description;
  final String title;
  final List<List<Story>>? features;
  final List<String> potentialUsers;
  final List<String> votes;

  factory Epic.fromJson(Map<String, dynamic> json) => _$EpicFromJson(json);
  Map<String, dynamic> toJson() => _$EpicToJson(this);

  @override
  List<Object?> get props =>
      [id, description, title, features, potentialUsers, votes];

  static Epic assignVotes(Epic epic, List<String> votes) {
    return Epic(
        id: epic.id,
        description: epic.description,
        title: epic.title,
        potentialUsers: epic.potentialUsers,
        votes: votes);
  }
}
