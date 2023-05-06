import 'package:json_annotation/json_annotation.dart';
import 'package:user_story_mapper/models/potentialUser.dart';
import 'package:user_story_mapper/models/epic.dart';
import 'dart:convert';

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
