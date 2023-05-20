import 'dart:convert';

import 'package:user_story_mapper/data/interfaces/IBoardApi.dart';
import 'package:user_story_mapper/models/board.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';
import 'package:meta/meta.dart';

class LocalStorageBoardApi extends IBoardApi {
  LocalStorageBoardApi({
    required SharedPreferences plugin,
  }) : _plugin = plugin {
    _init();
  }

  final SharedPreferences _plugin;

  //Here probably should be just board not list of it but need to understand seeded first
  final _boardStreamController = BehaviorSubject<List<Board>>.seeded(const []);

  @visibleForTesting
  static const kTodosCollectionKey = '__todos_collection_key__';

  String? _getValue(String key) => _plugin.getString(key);
  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  void _init() {
    final boardJson = _getValue(kTodosCollectionKey);
    if (boardJson != null) {
      final board = List<Map<dynamic, dynamic>>.from(
              json.decode(boardJson) as List)
          .map((jsonMap) => Board.fromJson(Map<String, dynamic>.from(jsonMap)))
          .toList();
      _boardStreamController.add(board);
    } else {
      _boardStreamController.add(const []);
    }
  }

  @override
  Future<void> createBoard(Board board) {
    // TODO: implement createBoard
    throw UnimplementedError();
  }

  @override
  Future<void> deleteBoard(String boardId) {
    // TODO: implement deleteBoard
    throw UnimplementedError();
  }

  @override
  Stream<Board> getBoard(String boardId) {
    return _boardStreamController.stream
        .map((boards) => boards.firstWhere((board) => board.id == boardId));
  }

  @override
  Future<List<Board>> getBoards() {
    // NOTE: THIS METHOD MY NOT BE NEEDED TO REMOVE IF NOT IMPLEMENTED
    // TODO: implement getBoards
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getAllBoardsId() {
//    return _boardStreamController.stream
    throw UnimplementedError();
  }

  @override
  Future<void> updateBoard(Board board) {
    // TODO: implement updateBoard
    throw UnimplementedError();
  }
}
