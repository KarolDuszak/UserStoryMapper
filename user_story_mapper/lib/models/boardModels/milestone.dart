import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_story_mapper/models/boardModels/epic.dart';
import 'package:uuid/uuid.dart';

part 'milestone.g.dart';

@JsonSerializable(explicitToJson: true)
class Milestone extends Equatable {
  Milestone({
    required this.id,
    required this.description,
    required this.title,
    required this.epics,
  });

  //Informations
  final String id;
  final String description;
  final String title;
  //Interaction
  final List<Epic> epics;

  factory Milestone.fromJson(Map<String, dynamic> json) =>
      _$MilestoneFromJson(json);
  Map<String, dynamic> toJson() => _$MilestoneToJson(this);

  @override
  List<Object?> get props => [id, description, title, epics];

  static Milestone createMvpMilestone() {
    return Milestone(
        id: Uuid().v4(), description: "description", title: "MVP", epics: []);
  }

  static Milestone createNewMilestone(String description, String title) {
    return Milestone(
        id: Uuid().v4(), description: description, title: title, epics: []);
  }
}
