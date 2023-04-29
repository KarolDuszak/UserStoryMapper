import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

@JsonSerializable(explicitToJson: true)
class PotentialUser {
  PotentialUser(
      {required this.id,
      required this.color,
      required this.name,
      required this.description});

  String id;
  Color color;
  String name;
  String description;

  static PotentialUser getEmptyObj() {
    return PotentialUser(
        id: "NULL",
        color: Colors.red,
        name: "NULL name",
        description: "NULL description");
  }

  //const PotentialUser.constConstructor(
    //  this.id, this.color, this.name, this.description);
}
