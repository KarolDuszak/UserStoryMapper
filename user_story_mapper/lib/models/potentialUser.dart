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

  final String id;
  final Color color;
  final String name;
  final String description;

  static PotentialUser getEmptyPotentialUserObj() {
    return PotentialUser(
        id: "NULL",
        color: Colors.red,
        name: "NULL name",
        description: "NULL description");
  }
}