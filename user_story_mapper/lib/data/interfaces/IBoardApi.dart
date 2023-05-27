import 'package:user_story_mapper/models/milestone.dart';
import 'package:user_story_mapper/models/potentialUser.dart';

import '../../models/board.dart';
import '../../models/epic.dart';

abstract class IBoardApi {
  Stream<Board> getBoard(String boardId);
  Future<void> createBoard(Board board);
  Future<void> updateBoard(Board board);
  Future<void> deleteBoard(String boardId);

  Stream<PotentialUser> getPotentialUser(
      String boardId, String potentialUserId);
  Stream<PotentialUser> getPotentialUsers(String boardId);
  Future<void> createPotentialUser(String boardId, PotentialUser potentialUser);
  Future<void> updatePotentialUser(String boardId, PotentialUser potentialUser);
  Future<void> deletePotentialUser(String boardId, String potentialUserId);

  Stream<Milestone> getMilestone(String boardId, String milestoneId);
  Stream<Milestone> getMilestones(String boardId);
  Future<void> createMilestone(String boardId, Milestone milestone);
  Future<void> updateMilestone(String boardId, Milestone milestone);
  Future<void> deleteMilestone(String boardId, String milestoneId);
  Future<void> moveEpicToDifferentMilestone(String boardId, String epicId,
      String fromMilestoneId, String toMilestoneId);

  Stream<Epic> getEpic(String boardId, String milestoneId, String epicId);
  Stream<Epic> getEpics(String boardId, String milestoneId);
  Future<void> createEpic(String boardId, String milestoneId, Epic epic);
  Future<void> updateEpic(String boardId, String milestoneId, Epic epic);
  Future<void> deleteEpic(String boardId, String milestoneId, String epicId);
}

class BoardNotFoundException implements Exception {}
