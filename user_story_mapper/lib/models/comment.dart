import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable(explicitToJson: true)
class Comment extends Equatable {
  Comment(
      {required this.id,
      required this.creatorId,
      required this.storyId,
      required this.content,
      required this.date});

  final String id;
  final String creatorId;
  //TODO: Remove this field
  //Redundant data due noSQL database this information will be retrieved from document structure
  final String storyId;
  final String content;
  final DateTime date;

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);

  @override
  List<Object?> get props => [id, creatorId, storyId, content, date];

  static Comment getEmptyCommentObj() {
    return Comment(
        id: "NULL id",
        creatorId: "NULL creatorId",
        storyId: "NULL storyId",
        content: "NULL content",
        date: DateTime.now());
  }
}
