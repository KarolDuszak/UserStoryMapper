import 'package:json_annotation/json_annotation.dart';
import 'package:user_story_mapper/models/comment.dart';
import 'package:user_story_mapper/models/potentialUser.dart';
import 'package:user_story_mapper/models/story.dart';

@JsonSerializable(explicitToJson: true)
class Feature {
  Feature(
      {required this.id,
      required this.description,
      required this.title,
      required this.stories,
      this.potentialUsers,
      this.comments,
      this.votes});

  //Informations
  String id;
  String description;
  String title;
  List<Story> stories;
  List<PotentialUser>? potentialUsers;
  Comment? comments;
  int? votes;

  static Feature getNewEmptyFeature(int id, String title, String description) {
    return Feature(
        id: id.toString(), description: description, title: title, stories: []);
  }

  static Feature getEmptyObj(int num) {
    return Feature(
        id: num.toString(),
        description: "NULL description",
        title: "NULL title",
        potentialUsers: List<PotentialUser>.generate(
            3, (index) => PotentialUser.getEmptyObj()),
        stories:
            List.generate(4, (innerIndex) => Story.getEmptyObj(innerIndex)));
  }
}
