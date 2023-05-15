import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'roleLabel.g.dart';

@JsonSerializable(explicitToJson: true)
class RoleLabel {
  RoleLabel({required this.id, required this.color, required this.title});

  //Informations
  String id;
  String color;
  String title;

  factory RoleLabel.fromJson(Map<String, dynamic> json) =>
      _$RoleLabelFromJson(json);
  Map<String, dynamic> toJson() => _$RoleLabelToJson(this);

  static RoleLabel getEmptyObj() {
    return RoleLabel(id: "NULL", color: "Colors.red", title: "NULL title");
  }
}
