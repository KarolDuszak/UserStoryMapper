import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_story_mapper/models/labelColor.dart';
import 'package:uuid/uuid.dart';

part 'potentialUser.g.dart';

@JsonSerializable(explicitToJson: true)
class PotentialUser extends Equatable {
  PotentialUser(
      {required this.id,
      required this.color,
      required this.name,
      required this.description});

  final String id;
  final ColorLabel color;
  final String name;
  final String description;

  factory PotentialUser.fromJson(Map<String, dynamic> json) =>
      _$PotentialUserFromJson(json);
  Map<String, dynamic> toJson() => _$PotentialUserToJson(this);

  @override
  List<Object?> get props => [id, color, name, description];

  static PotentialUser getEmptyObj() {
    return PotentialUser(
        id: Uuid().v4(),
        color: ColorLabel.blue,
        name: "NULL name",
        description: "NULL description");
  }

  //const PotentialUser.constConstructor(
  //  this.id, this.color, this.name, this.description);
}
