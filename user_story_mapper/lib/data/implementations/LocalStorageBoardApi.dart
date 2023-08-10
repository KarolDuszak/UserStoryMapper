import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_story_mapper/data/interfaces/IBoardApi.dart';
import 'package:user_story_mapper/models/board.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';
import 'package:meta/meta.dart';
import 'package:user_story_mapper/models/potentialUser.dart';
import 'package:user_story_mapper/models/milestone.dart';
import 'package:user_story_mapper/models/epic.dart';
import 'package:user_story_mapper/models/story.dart';

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
  Stream getBoard(String boardId) {
    throw UnimplementedError();
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
  Future<void> createPotentialUser(
      String boardId, PotentialUser potentialUser) {
    // TODO: implement createPotentialUser
    throw UnimplementedError();
  }

  @override
  Future<void> deletePotentialUser(String boardId, String potentialUserId) {
    // TODO: implement deletePotentialUser
    throw UnimplementedError();
  }

  @override
  Stream<PotentialUser> getPotentialUser(
      String boardId, String potentialUserId) {
    // TODO: implement getPotentialUser
    throw UnimplementedError();
  }

  @override
  Future<PotentialUser> getPotentialUsers(String boardId) {
    // TODO: implement getPotentialUsers
    throw UnimplementedError();
  }

  @override
  Future<void> updatePotentialUser(
      String boardId, PotentialUser potentialUser) {
    // TODO: implement updatePotentialUser
    throw UnimplementedError();
  }

  @override
  Future<void> unvoteForEpic(
      String boardId, String milestoneId, String epicId) {
    // TODO: implement unvoteForEpic
    throw UnimplementedError();
  }

  @override
  Future<void> unvoteForStory(
      String boardId, String milestoneId, String epicId, String storyId) {
    // TODO: implement unvoteForStory
    throw UnimplementedError();
  }

  @override
  Future<void> voteForEpic(String boardId, String milestoneId, String epicId) {
    // TODO: implement voteForEpic
    throw UnimplementedError();
  }

  @override
  Future<void> voteForStory(
      String boardId, String milestoneId, String epicId, String storyId) {
    // TODO: implement voteForStory
    throw UnimplementedError();
  }

  @override
  Future<void> updateEpic(String boardId, Epic epic) {
    // TODO: implement updateEpic
    throw UnimplementedError();
  }

  @override
  Future<void> updateStory(String boardId, String epicId, Story story) {
    // TODO: implement updateStory
    throw UnimplementedError();
  }

  @override
  Future<void> updateEpicProperties(String boardId, Story epic) {
    // TODO: implement updateEpicProperties
    throw UnimplementedError();
  }
  
  @override
  Future<void> createEpic(String boardId,int milestoneIndex, Epic epic) {
    // TODO: implement createEpic
    throw UnimplementedError();
  }
  
  @override
  Future<void> createStory(String boardId, String epicId, int featureIndex, Story story) {
    // TODO: implement createStory
    throw UnimplementedError();
  }
  
  @override
  Future<void> deleteEpic(String boardId, String epicId) {
    // TODO: implement deleteEpic
    throw UnimplementedError();
  }
  
  @override
  Future<void> deleteStory(String boardId, String epicId, String story) {
    // TODO: implement deleteStory
    throw UnimplementedError();
  }
}
