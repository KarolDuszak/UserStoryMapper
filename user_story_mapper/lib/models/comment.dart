import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable(explicitToJson: true)
class Comment {
  Comment(
      {required this.id,
      required this.creatorId,
      required this.storyId,
      required this.content,
      required this.date});

  String id;
  String creatorId;
  String storyId;
  String content;
  DateTime date;

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);

  static Comment getEmptyCommentObj() {
    return Comment(
        id: "NULL id",
        creatorId: "NULL creatorId",
        storyId: "NULL storyId",
        content: "NULL content",
        date: DateTime.now());
  }
}
