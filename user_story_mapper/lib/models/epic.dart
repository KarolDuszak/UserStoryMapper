import 'package:json_annotation/json_annotation.dart';
import 'package:user_story_mapper/models/potentialUser.dart';
import 'package:user_story_mapper/models/feature.dart';
import 'dart:convert';

@JsonSerializable(explicitToJson: true)
class Epic {
  Epic(
      {required this.id,
      required this.description,
      required this.title,
      required this.features});

  //Informations
   String id;
  String description;
  String title;
  List<Feature> features;

  static Epic getEmptyObj(int num) {
    return Epic(
        id: "NULL",
        description: "NULL description",
        title: "NULL title",
        features: List.generate(10, (innerIndex) => Feature.getEmptyObj(innerIndex)));
  }
}
