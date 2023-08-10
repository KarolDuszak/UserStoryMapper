import '../models/story.dart';

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
}
