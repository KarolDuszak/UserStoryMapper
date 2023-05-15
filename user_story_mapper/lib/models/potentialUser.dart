import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_story_mapper/models/labelColor.dart';

part 'potentialUser.g.dart';

@JsonSerializable(explicitToJson: true)
class PotentialUser {
  PotentialUser(
      {required this.id,
      required this.color,
      required this.name,
      required this.description});

  String id;
  ColorLabel color;
  String name;
  String description;

  factory PotentialUser.fromJson(Map<String, dynamic> json) =>
      _$PotentialUserFromJson(json);
  Map<String, dynamic> toJson() => _$PotentialUserToJson(this);

  static PotentialUser getEmptyObj() {
    return PotentialUser(
        id: "NULL",
        color: ColorLabel.blue,
        name: "NULL name",
        description: "NULL description");
  }

  //const PotentialUser.constConstructor(
  //  this.id, this.color, this.name, this.description);
}
