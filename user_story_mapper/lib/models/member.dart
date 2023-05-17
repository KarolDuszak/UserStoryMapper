import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_story_mapper/models/roleLabel.dart';

part 'member.g.dart';

@JsonSerializable(explicitToJson: true)
class Member extends Equatable {
  Member(
      {required this.id,
      required this.role,
      required this.voterRemaining,
      required this.roleLabel});

  //Informations
  final String id;
  final String role;
  final int? voterRemaining;
  final RoleLabel? roleLabel;

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
  Map<String, dynamic> toJson() => _$MemberToJson(this);

  @override
  List<Object?> get props => [id, role, voterRemaining, roleLabel];

  static Member getEmptyObj() {
    return Member(
        id: "NULL",
        role: "NULL email",
        voterRemaining: 0,
        roleLabel: RoleLabel.getEmptyObj());
  }
}
