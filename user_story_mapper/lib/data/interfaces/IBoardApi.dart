import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_story_mapper/models/milestone.dart';
import 'package:user_story_mapper/models/potentialUser.dart';

import '../../models/board.dart';
import '../../models/epic.dart';
import '../../models/story.dart';

abstract class IBoardApi {
  Stream getBoard(String boardId);
  Future<void> createBoard(Board board);
  Future<void> updateBoard(Board board);
  Future<void> deleteBoard(String boardId);

  Future<void> createEpic(String boardId, int milestoneIndex, Epic epic);
  Future<void> updateEpic(String boardId, Epic epic);
  Future<void> updateEpicProperties(String boardId, Story epic);
  Future<void> deleteEpic(String boardId, String epicId);

  Future<void> createStory(
      String boardId, String epicId, int featureIndex, Story story);
  Future<void> updateStory(String boardId, String epicId, Story story);
  Future<void> deleteStory(String boardId, String epicId, String story);

  Future<void> updatePotentialUser(String boardId, PotentialUser potentialUser);
  Future<void> deletePotentialUser(String boardId, String potentialUserId);
  Future<List<PotentialUser>> getAvailablePotentialUsers(String boardId);

  Future<void> voteForEpic(String boardId, String milestoneId, String epicId);
  Future<void> unvoteForEpic(String boardId, String milestoneId, String epicId);
  Future<void> voteForStory(
      String boardId, String milestoneId, String epicId, String storyId);
  Future<void> unvoteForStory(
      String boardId, String milestoneId, String epicId, String storyId);
}

class BoardNotFoundException implements Exception {}
