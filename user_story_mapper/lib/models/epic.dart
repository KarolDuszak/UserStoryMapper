import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_story_mapper/models/comment.dart';
import 'package:user_story_mapper/models/potentialUser.dart';
import 'package:user_story_mapper/models/story.dart';

@JsonSerializable(explicitToJson: true)
class Epic {
  Epic(
      {required this.id,
      required this.description,
      required this.title,
      required this.features,
      this.potentialUsers,
      this.comments,
      this.votes});

  //Informations
  String id;
  String description;
  String title;
  List<List<Story>> features;
  List<PotentialUser>? potentialUsers;
  Comment? comments;
  int? votes;

  static Epic getEmptyObj(int num) {
    var uuid = Uuid();
    return Epic(
        id: uuid.v1(),
        description: "NULL description",
        title: "NULL title ${num}",
        features: List.generate(
            5,
            (outerIndex) => List.generate(
                4,
                (innerindex) =>
                    Story.getEmptyObj("${outerIndex},${innerindex}"))));
  }
}
