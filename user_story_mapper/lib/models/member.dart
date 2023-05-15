import 'package:json_annotation/json_annotation.dart';
import 'package:user_story_mapper/models/roleLabel.dart';

part 'member.g.dart';

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

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
  Map<String, dynamic> toJson() => _$MemberToJson(this);

  static Member getEmptyObj() {
    return Member(
        id: "NULL",
        role: "NULL email",
        voterRemaining: 0,
        roleLabel: RoleLabel.getEmptyObj());
  }
}
