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
      required this.features,
      required this.potentialUsers});

  //Informations
  final String id;
  String description;
  String title;
  //Interaction
  List<PotentialUser> potentialUsers;
  List<Feature> features;

  static Epic getEmptyObj() {
    return Epic(
        id: "NULL",
        description: "NULL description",
        title: "NULL title",
        potentialUsers: List<PotentialUser>.filled(
            2, PotentialUser.getEmptyObj()),
        features: List<Feature>.filled(3, Feature.getEmptyObj()));
  }
}
