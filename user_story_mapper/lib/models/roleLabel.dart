import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_story_mapper/models/potentialUser.dart';
import 'package:user_story_mapper/models/epic.dart';
import 'dart:convert';

@JsonSerializable(explicitToJson: true)
class RoleLabel {
  RoleLabel({required this.id, required this.color, required this.title});

  //Informations
  final String id;
  Color color;
  String title;

  static RoleLabel getEmptyObj() {
    return RoleLabel(id: "NULL", color: Colors.red, title: "NULL title");
  }
}
