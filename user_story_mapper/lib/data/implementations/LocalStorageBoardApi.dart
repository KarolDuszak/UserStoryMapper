import 'dart:convert';

import 'package:user_story_mapper/data/interfaces/IBoardApi.dart';
import 'package:user_story_mapper/models/board.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';
import 'package:meta/meta.dart';
import 'package:user_story_mapper/models/potentialUser.dart';
import 'package:user_story_mapper/models/milestone.dart';
import 'package:user_story_mapper/models/epic.dart';

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
  Future<void> createBoard(Board board) async {
    _boardStreamController.add([..._boardStreamController.value, board]);
  }

  @override
  Future<void> deleteBoard(String boardId) {
    final boards = [..._boardStreamController.value];
    final index = boards.indexWhere((board) => board.id == boardId);

    if (index == -1) {
      throw BoardNotFoundException();
    } else {
      boards.removeAt(index);
      _boardStreamController.add(boards);
      return _setValue(
        kTodosCollectionKey,
        json.encode(boards),
      );
    }
  }

  @override
  Stream<Board> getBoard(String boardId) {
    return _boardStreamController.stream
        .map((boards) => boards.firstWhere((board) => board.id == boardId));
  }

  @override
  Future<void> updateBoard(Board board) {
    // ... spread operator inserts all elements of list into another list
    // ..? does this same but check for null
    final boards = [..._boardStreamController.value];
    final index = boards.indexWhere((b) => b.id == board.id);
    if (index >= 0) {
      boards[index] = board;
    } else {
      boards.add(board);
    }
    _boardStreamController.add(boards);
    return _setValue(
      kTodosCollectionKey,
      json.encode(boards),
    );
  }

  @override
  Future<void> createEpic(String boardId, String milestoneId, Epic epic) {
    // TODO: implement createEpic
    throw UnimplementedError();
  }

  @override
  Future<void> createMilestone(String boardId, Milestone milestone) {
    // TODO: implement createMilestone
    throw UnimplementedError();
  }

  @override
  Future<void> createPotentialUser(
      String boardId, PotentialUser potentialUser) {
    // TODO: implement createPotentialUser
    throw UnimplementedError();
  }

  @override
  Future<void> deleteEpic(String boardId, String milestoneId, String epicId) {
    // TODO: implement deleteEpic
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMilestone(String boardId, String milestoneId) {
    // TODO: implement deleteMilestone
    throw UnimplementedError();
  }

  @override
  Future<void> deletePotentialUser(String boardId, String potentialUserId) {
    // TODO: implement deletePotentialUser
    throw UnimplementedError();
  }

  @override
  Stream<Epic> getEpic(String boardId, String milestoneId, String epicId) {
    // TODO: implement getEpic
    throw UnimplementedError();
  }

  @override
  Stream<Epic> getEpics(String boardId, String milestoneId) {
    // TODO: implement getEpics
    throw UnimplementedError();
  }

  @override
  Stream<Milestone> getMilestone(String boardId, String milestoneId) {
    // TODO: implement getMilestone
    throw UnimplementedError();
  }

  @override
  Stream<Milestone> getMilestones(String boardId) {
    // TODO: implement getMilestones
    throw UnimplementedError();
  }

  @override
  Stream<PotentialUser> getPotentialUser(
      String boardId, String potentialUserId) {
    // TODO: implement getPotentialUser
    throw UnimplementedError();
  }

  @override
  Stream<PotentialUser> getPotentialUsers(String boardId) {
    // TODO: implement getPotentialUsers
    throw UnimplementedError();
  }

  @override
  Future<void> moveEpicToDifferentMilestone(String boardId, String epicId,
      String fromMilestoneId, String toMilestoneId, int milestoneListPosition) {
    // TODO: implement moveEpicToDifferentMilestone
    throw UnimplementedError();
  }

  @override
  Future<void> updateEpic(String boardId, String milestoneId, Epic epic) {
    // TODO: implement updateEpic
    throw UnimplementedError();
  }

  @override
  Future<void> updateMilestone(String boardId, Milestone milestone) {
    // TODO: implement updateMilestone
    throw UnimplementedError();
  }

  @override
  Future<void> updatePotentialUser(
      String boardId, PotentialUser potentialUser) {
    // TODO: implement updatePotentialUser
    throw UnimplementedError();
  }
}
