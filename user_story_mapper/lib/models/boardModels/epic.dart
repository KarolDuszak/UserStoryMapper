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

  static Epic getEmptyObj(int num, List<String> potUsers) {
    var uuid = Uuid();
    return Epic(
        id: uuid.v1(),
        description: "NULL description",
        title: "NULL title ${num}",
        votes: [],
        potentialUsers: potUsers,
        features: List.generate(
            5,
            (outerIndex) => List.generate(
                4,
                (innerindex) => Story.getEmptyObj(
                    "${outerIndex},${innerindex}", potUsers))));
  }
}
