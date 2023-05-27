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
  Future<PotentialUser> getPotentialUsers(String boardId);
  Future<void> createPotentialUser(String boardId, PotentialUser potentialUser);
  Future<void> updatePotentialUser(String boardId, PotentialUser potentialUser);
  Future<void> deletePotentialUser(String boardId, String potentialUserId);

  Stream<Milestone> getMilestone(String boardId, String milestoneId);
  Future<Milestone> getMilestones(String boardId);
  Future<void> createMilestone(String boardId, Milestone milestone);
  Future<void> updateMilestone(String boardId, Milestone milestone);
  Future<void> deleteMilestone(String boardId, String milestoneId);
  Future<void> moveEpicToDifferentMilestone(String boardId, String epicId,
      String fromMilestoneId, String toMilestoneId, int milestoneListPosition);

  Stream<Epic> getEpic(String boardId, String milestoneId, String epicId);
  Future<Epic> getEpics(String boardId, String milestoneId);
  Future<void> createEpic(String boardId, String milestoneId, Epic epic);
  Future<void> updateEpic(String boardId, String milestoneId, Epic epic);
  Future<void> deleteEpic(String boardId, String milestoneId, String epicId);

  Future<void> voteForEpic(String boardId, String milestoneId, String epicId);
  Future<void> unvoteForEpic(String boardId, String milestoneId, String epicId);
  Future<void> voteForStory(
      String boardId, String milestoneId, String epicId, String storyId);
  Future<void> unvoteForStory(
      String boardId, String milestoneId, String epicId, String storyId);
}

class BoardNotFoundException implements Exception {}
