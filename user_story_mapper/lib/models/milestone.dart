import 'package:json_annotation/json_annotation.dart';
import 'package:user_story_mapper/models/epic.dart';

part 'milestone.g.dart';

@JsonSerializable(explicitToJson: true)
class Milestone {
  Milestone({
    required this.id,
    required this.description,
    required this.title,
    required this.epics,
    //required this.potentialUsers,
  });

  //Informations
  String id;
  String description;
  String title;
  //Interaction
  List<Epic> epics;

  factory Milestone.fromJson(Map<String, dynamic> json) =>
      _$MilestoneFromJson(json);
  Map<String, dynamic> toJson() => _$MilestoneToJson(this);

  static Milestone getEmptyObj(int num) {
    return Milestone(
        id: "NULL",
        description: "NULL description",
        title: "NULL title",
        //potentialUsers: List<PotentialUser>.filled(
        //    2, PotentialUser.getEmptyObj()),
        epics: List.generate(3, (innerIndex) => Epic.getEmptyObj(innerIndex)));
  }
}
