import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_story_mapper/models/boardModels/milestone.dart';
import 'package:user_story_mapper/models/boardModels/potentialUser.dart';

import '../../models/boardModels/board.dart';
import '../../models/boardModels/epic.dart';
import '../../models/boardModels/member.dart';
import '../../models/boardModels/story.dart';
import '../../models/userModels/boardInvitation.dart';

abstract class IBoardApi {
  Stream getBoard(String boardId);
  Future<Board> getBoardObject(String boardId);
  Future<void> createBoard(Board board);
  Future<void> updateBoard(Board board);
  Future<void> deleteBoard(String boardId);
  Future<void> moveEpic(String boardId, String epicId, int mIndex, int eIndex);
  Future<void> moveFeature(String boardId, String epicId, int fOldIndex,
      int mIndex, int eIndex, int fIndex);

  Future<void> createMilestone(String boardId, Milestone milestone);
  Future<void> updateMilestoneProperties(
      String boardId, String milestoneId, String title, String description);

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

  Future<void> voteForEpic(String boardId, String epicId, String userId);
  Future<void> voteForStory(
      String boardId, String epicId, String storyId, String userId);

  Future<void> inviteToBoard(BoardInvitation invitation, Member member);
  Future<void> cancelInvitation(String reciever, String boardId);

  Future<void> deleteMember(String boardId, String userId);
  Future<void> addMember(String boardId, Member member);
}
