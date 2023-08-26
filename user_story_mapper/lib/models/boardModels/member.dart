import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'member.g.dart';

@JsonSerializable(explicitToJson: true)
class Member extends Equatable {
  Member(
      {required this.id,
      required this.role,
      required this.name,
      required this.votesUsed,
      required this.invitationAccepted});

  //Informations
  final String id;
  final String role;
  final String name;
  final int? votesUsed;
  bool invitationAccepted;

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
  Map<String, dynamic> toJson() => _$MemberToJson(this);

  @override
  List<Object?> get props => [id, role, name, votesUsed, invitationAccepted];

  static Member getEmptyObj() {
    return Member(
        id: "NULL",
        role: "NULL email",
        name: "NULL Name",
        votesUsed: 0,
        invitationAccepted: false);
  }
}
