import '../models/boardModels/board.dart';
import '../models/boardModels/member.dart';
import '../models/boardModels/story.dart';

class Util {
  static List<List<Story>> decodeMapToMatrixOfStories(
      Map<String, dynamic> json) {
    final map = Map<String, dynamic>.from(json);
    List<List<Story>> result = [];

    map.forEach((stringIndex, value) {
      Map<String, dynamic> row = Map<String, dynamic>.from(value);
      List<Story> rowList = [];
      row.forEach((key, value) {
        rowList.add(Story.fromJson(value));
      });
      result.add(rowList);
    });
    return result;
  }

  static Map<String, dynamic> encodeMatrixOfStoriesToMap(
      List<List<Story>>? features) {
    Map<String, Map<String, dynamic>> result = {};
    int index = 0;
    for (List<Story> row in features!) {
      int jIndex = 0;
      result.addEntries([MapEntry(index.toString(), {})]);
      for (Story story in row) {
        result[index.toString()]
            ?.addEntries([MapEntry(jIndex.toString(), story.toJson())]);
        jIndex++;
      }
      index++;
    }
    return result;
  }

  static List<Member> decodeMapToMebmers(Map<String, dynamic> json) {
    final map = Map<String, dynamic>.from(json);
    List<Member> result = [];

    map.forEach((stringIndex, value) {
      result.add(Member.fromJson(value));
    });
    return result;
  }

  static Map<String, dynamic> encodeMembersToMap(List<Member> members) {
    Map<String, dynamic> result = {};
    for (Member member in members) {
      result.addEntries([MapEntry(member.id, member.toJson())]);
    }
    return result;
  }

  static List<int> getEpicPosition(Board board, String epicId) {
    for (int mIndex = 0; mIndex < board.milestones.length; mIndex++) {
      int eIndex = board.milestones[mIndex].epics
          .indexWhere((element) => element.id == epicId);

      if (eIndex != -1) {
        return [mIndex, eIndex];
      }
    }

    throw Exception("Epic ${epicId} not found in board ${board.id}");
  }
}
