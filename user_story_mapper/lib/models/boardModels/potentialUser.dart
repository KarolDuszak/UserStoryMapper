import 'dart:js_interop';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_story_mapper/models/boardModels/labelColor.dart';
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
  late final ColorLabel color;
  final String name;
  final String description;

  factory PotentialUser.fromJson(Map<String, dynamic> json) =>
      _$PotentialUserFromJson(json);
  Map<String, dynamic> toJson() => _$PotentialUserToJson(this);

  @override
  List<Object?> get props => [id, color, name, description];

  static PotentialUser createNew() {
    return PotentialUser(
        id: Uuid().v1(), color: ColorLabel.grey, name: "", description: "");
  }
}

List<PotentialUser> getPotentialUsersFromIds(
    List<PotentialUser> availablePotUsers, List<String> potentialUsers) {
  List<PotentialUser> result = [];
  for (String u in potentialUsers) {
    PotentialUser user =
        availablePotUsers.firstWhere((element) => element.id == u);
    if (!user.isNull) {
      result.add(user);
    }
  }
  return result;
}
