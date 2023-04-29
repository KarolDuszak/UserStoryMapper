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
      required this.stories});

  //Informations
  String id;
  String description;
  String title;
  List<Story> stories;

  static Feature getEmptyObj(int num) {
    return Feature(
        id: num.toString(),
        description: "NULL description",
        title: "NULL title",
        stories:
            List.generate(10, (innerIndex) => Story.getEmptyObj(innerIndex)));
  }
}
