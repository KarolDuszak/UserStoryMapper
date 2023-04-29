import 'package:json_annotation/json_annotation.dart';
import 'package:user_story_mapper/models/potentialUser.dart';
import 'package:user_story_mapper/models/story.dart';
import 'dart:convert';

@JsonSerializable(explicitToJson: true)
class Feature {
  Feature(
      {required this.id,
      required this.description,
      required this.title,
      required this.stories,
      required this.potentialUsers});

  //Informations
  String id;
  String description;
  String title;
  //Interaction
  List<PotentialUser> potentialUsers;
  List<Story> stories;

  static Feature getEmptyObj(int num) {
    return Feature(
        id: num.toString(),
        description: "NULL description",
        title: "NULL title",
        potentialUsers:
            List<PotentialUser>.filled(2, PotentialUser.getEmptyObj()),
        stories:
            List.generate(10, (innerIndex) => Story.getEmptyObj(innerIndex)));
  }
}
