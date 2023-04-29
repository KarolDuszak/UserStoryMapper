import 'package:json_annotation/json_annotation.dart';
import 'package:user_story_mapper/models/roleLabel.dart';
import 'package:user_story_mapper/models/boardInvitation.dart';
import 'dart:convert';

@JsonSerializable(explicitToJson: true)
class Member {
  Member(
      {required this.id,
      required this.role,
      required this.voterRemaining,
      required this.roleLabel});

  //Informations
   String id;
  String role;
  int? voterRemaining;
  RoleLabel? roleLabel;

  static Member getEmptyObj() {
    return Member(
        id: "NULL",
        role: "NULL email",
        voterRemaining: 0,
        roleLabel: RoleLabel.getEmptyObj());
  }
}
