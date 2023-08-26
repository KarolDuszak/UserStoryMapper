import 'package:json_annotation/json_annotation.dart';

part 'boardData.g.dart';

@JsonSerializable(explicitToJson: true)
class BoardData {
  BoardData(
      {required this.boardId, required this.name, required this.description});

  //Informations
  String boardId;
  String name;
  String description;

  factory BoardData.fromJson(Map<String, dynamic> json) =>
      _$BoardDataFromJson(json);
  Map<String, dynamic> toJson() => _$BoardDataToJson(this);

  static BoardData boardData(String boardId, String name, String description) {
    return BoardData(boardId: boardId, name: name, description: description);
  }
}
