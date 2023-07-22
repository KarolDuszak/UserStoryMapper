import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_story_mapper/models/milestone.dart';
import 'package:user_story_mapper/models/potentialUser.dart';

import '../../models/board.dart';
import '../../models/epic.dart';

abstract class IBoardApi {
  Stream<QuerySnapshot> getBoard(String boardId);
  Future<void> createBoard(Board board);
  Future<void> updateBoard(Board board);
  Future<void> deleteBoard(String boardId);

  Stream<PotentialUser> getPotentialUser(
      String boardId, String potentialUserId);
  Future<PotentialUser> getPotentialUsers(String boardId);
  Future<void> createPotentialUser(String boardId, PotentialUser potentialUser);
  Future<void> updatePotentialUser(String boardId, PotentialUser potentialUser);
  Future<void> deletePotentialUser(String boardId, String potentialUserId);

  Future<void> voteForEpic(String boardId, String milestoneId, String epicId);
  Future<void> unvoteForEpic(String boardId, String milestoneId, String epicId);
  Future<void> voteForStory(
      String boardId, String milestoneId, String epicId, String storyId);
  Future<void> unvoteForStory(
      String boardId, String milestoneId, String epicId, String storyId);
}

class BoardNotFoundException implements Exception {}
