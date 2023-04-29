import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

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

  static Comment getEmptyCommentObj() {
    return Comment(
        id: "NULL id",
        creatorId: "NULL creatorId",
        storyId: "NULL storyId",
        content: "NULL content",
        date: DateTime.now());
  }
}
