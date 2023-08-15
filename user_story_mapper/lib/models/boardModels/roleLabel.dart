import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_story_mapper/models/boardModels/labelColor.dart';

part 'roleLabel.g.dart';

@JsonSerializable(explicitToJson: true)
class RoleLabel extends Equatable {
  RoleLabel({required this.id, required this.color, required this.title});

  //Informations
  final String id;
  final ColorLabel color;
  final String title;

  @override
  List<Object?> get props => [id, color, title];

  factory RoleLabel.fromJson(Map<String, dynamic> json) =>
      _$RoleLabelFromJson(json);
  Map<String, dynamic> toJson() => _$RoleLabelToJson(this);

  static RoleLabel getEmptyObj() {
    return RoleLabel(id: "NULL", color: ColorLabel.green, title: "NULL title");
  }
}
