import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_story_mapper/models/userModels/boardInvitation.dart';

import 'boardData.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User extends Equatable {
  const User(
      {required this.id,
      required this.email,
      required this.name,
      required this.boards});

  //Informations
  final String id;
  final String email;
  final String name;
  final List<BoardData> boards;

  /// Empty user which represents an unauthenticated user.
  static const empty = User(id: '', email: '', name: '', boards: []);

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == User.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != User.empty;

  set boards(List<BoardData>? boards) {
    this.boards = boards;
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [id, email, name, boards];
}