import 'dart:async';

import 'package:user_story_mapper/data/interfaces/IBoardApi.dart';
import 'package:user_story_mapper/models/board.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_story_mapper/models/epic.dart';
import 'package:user_story_mapper/models/milestone.dart';
import 'package:user_story_mapper/models/potentialUser.dart';
import 'package:user_story_mapper/models/story.dart';

class FirebaseBoardApi extends IBoardApi {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference boardsRef =
      FirebaseFirestore.instance.collection('boards');

  @override
  Future<void> createBoard(Board board) {
    return boardsRef
        .doc(board.id)
        .set(board.toJson())
        .then((value) => print("Board Created"));
  }

  @override
  Future<void> deleteBoard(String boardId) {
    return boardsRef
        .doc(boardId)
        .delete()
        .then((value) => print("Board $boardId Deleted"))
        .onError((error, stackTrace) => print(error));
  }

  @override
  Future<Board> getBoardObject(String boardId) async {
    var snapshot = await boardsRef.doc(boardId).get();

    var data = snapshot.data() as Map<String, dynamic>;
    Board board = Board.fromJson(data);
    return board;
  }

  @override
  Stream getBoard(String boardId) {
    Stream documentStream = FirebaseFirestore.instance
        .collection('boards')
        .doc(boardId)
        .snapshots();

    return documentStream;
  }

  @override
  Future<void> updateBoard(Board board) {
    return boardsRef
        .doc(board.id)
        .update(board.toJson())
        .then((value) => print("Board ${board.id} Updated"))
        .onError((error, stackTrace) => print(error));
  }

  @override
  Future<void> updateMilestoneProperties(String boardId, String milestoneId,
      String title, String description) async {
    Board board = await getBoardObject(boardId);

    var mIndex =
        board.milestones.indexWhere((element) => element.id == milestoneId);

    if (mIndex == -1) {
      throw Exception(
          "Cound not find milestone ${title} with id ${milestoneId}");
    }

    Milestone newMilestone = Milestone(
        id: board.milestones[mIndex].id,
        title: title,
        description: description,
        epics: board.milestones[mIndex].epics);

    board.milestones.removeAt(mIndex);
    board.milestones.insert(mIndex, newMilestone);
    updateBoard(board);
    return;
  }

  @override
  Future<void> moveEpic(
      String boardId, String epicId, int mIndex, int eIndex) async {
    Board board = await getBoardObject(boardId);

    for (int m = 0; m < board.milestones.length; m++) {
      int e = board.milestones[m].epics
          .indexWhere((element) => element.id == epicId);

      if (e == -1) {
        continue;
      }
      Epic newEpic = board.milestones[m].epics[e];
      board.milestones[m].epics.removeAt(e);
      if (board.milestones[mIndex].epics.length <= eIndex) {
        board.milestones[mIndex].epics.add(newEpic);
      } else {
        board.milestones[mIndex].epics.insert(eIndex, newEpic);
      }
      updateBoard(board);
      return;
    }

    throw Exception(
        "Could not move Epic ${epicId} to mileston nr. ${mIndex} position ${eIndex}");
  }

  @override
  Future<void> moveFeature(
      String boardId, String epicId, int mIndex, int eIndex, int fIndex) {
    // TODO: implement moveFeature
    throw UnimplementedError();
  }

  @override
  Future<void> createEpic(String boardId, int milestoneIndex, Epic epic) async {
    Board board = await getBoardObject(boardId);

    board.milestones[milestoneIndex].epics.add(epic);

    updateBoard(board);
  }

  @override
  Future<void> updateEpic(String boardId, Epic epic) async {
    Board board = await getBoardObject(boardId);

    for (var m in board.milestones) {
      int index = m.epics.indexWhere((element) => element.id == epic.id);

      if (index != -1) {
        int mIndex =
            board.milestones.indexWhere((element) => element.id == m.id);
        board.milestones[mIndex].epics.removeAt(index);
        board.milestones[mIndex].epics.insert(index, epic);
        updateBoard(board);
        return;
      }
    }

    throw Exception("Could not find epic to update");
  }

  @override
  Future<void> updateEpicProperties(String boardId, Story epic) async {
    Board board = await getBoardObject(boardId);

    for (var m in board.milestones) {
      int index = m.epics.indexWhere((element) => element.id == epic.id);

      if (index != -1) {
        int mIndex =
            board.milestones.indexWhere((element) => element.id == m.id);
        Epic prevEpic = board.milestones[mIndex].epics[index];
        Epic newEpic = Epic(
            id: epic.id,
            description: epic.description,
            title: epic.title,
            features: prevEpic.features,
            potentialUsers: epic.potentialUsers,
            votes: epic.votes);
        board.milestones[mIndex].epics.removeAt(index);
        board.milestones[mIndex].epics.insert(index, newEpic);
        updateBoard(board);
        return;
      }
    }

    throw Exception("Could not find epic to update");
  }

  @override
  Future<void> deleteEpic(String boardId, String epicId) async {
    Board board = await getBoardObject(boardId);

    for (var m in board.milestones) {
      int index = m.epics.indexWhere((element) => element.id == epicId);

      if (index != -1) {
        int mIndex =
            board.milestones.indexWhere((element) => element.id == m.id);
        board.milestones[mIndex].epics.removeAt(index);
        updateBoard(board);
        return;
      }
    }

    throw Exception("Could not find epic to delete");
  }

  @override
  Future<void> createStory(
      String boardId, String epicId, int featureIndex, Story story) async {
    Board board = await getBoardObject(boardId);

    for (var m in board.milestones) {
      int eIndex = m.epics.indexWhere((element) => element.id == epicId);
      if (eIndex == -1) {
        continue;
      }

      int mIndex = board.milestones.indexWhere((element) => element.id == m.id);

      if (board.milestones[mIndex].epics[eIndex].features!.isEmpty ||
          board.milestones[mIndex].epics[eIndex].features!.length <=
              featureIndex) {
        board.milestones[mIndex].epics[eIndex].features?.add([story]);
      } else {
        board.milestones[mIndex].epics[eIndex].features?[featureIndex]
            .add(story);
      }
      updateBoard(board);
      return;
    }

    throw Exception("Could not create new story");
  }

  @override
  Future<void> updateStory(String boardId, String epicId, Story story) async {
    Board board = await getBoardObject(boardId);

    for (var m in board.milestones) {
      int eIndex = m.epics.indexWhere((element) => element.id == epicId);
      if (eIndex == -1) {
        continue;
      }

      int mIndex = board.milestones.indexWhere((element) => element.id == m.id);
      for (List<Story> feature
          in board.milestones[mIndex].epics[eIndex].features!) {
        int sIndex = feature.indexWhere((element) => element.id == story.id);

        if (sIndex == -1) {
          continue;
        }
        int? fIndex = board.milestones[mIndex].epics[eIndex].features
            ?.indexWhere((element) => element.first.id == feature.first.id);

        if (fIndex == -1) {
          throw Exception("For some reason feature not found");
        }

        board.milestones[mIndex].epics[eIndex].features?[fIndex!]
            .removeAt(sIndex);
        board.milestones[mIndex].epics[eIndex].features?[fIndex!]
            .insert(sIndex, story);
        updateBoard(board);
        return;
      }
    }

    throw Exception("Could not find story to update in database");
  }

  @override
  Future<void> deleteStory(
      String boardId, String epicId, String storyId) async {
    Board board = await getBoardObject(boardId);

    for (var m in board.milestones) {
      int eIndex = m.epics.indexWhere((element) => element.id == epicId);
      if (eIndex == -1) {
        continue;
      }

      int mIndex = board.milestones.indexWhere((element) => element.id == m.id);
      for (List<Story> feature
          in board.milestones[mIndex].epics[eIndex].features!) {
        int sIndex = feature.indexWhere((element) => element.id == storyId);

        if (sIndex == -1) {
          continue;
        }
        int? fIndex = board.milestones[mIndex].epics[eIndex].features
            ?.indexWhere((element) => element.first.id == feature.first.id);

        if (fIndex == -1) {
          throw Exception("For some reason feature not found");
        }

        board.milestones[mIndex].epics[eIndex].features?[fIndex!]
            .removeAt(sIndex);
        updateBoard(board);
        return;
      }
    }

    throw Exception("Could not find story to delete in database");
  }

  @override
  Future<void> deletePotentialUser(
      String boardId, String potentialUserId) async {
    Board board = await getBoardObject(boardId);

    int uIndex = board.potentialUsers
        .indexWhere((element) => element.id == potentialUserId);

    if (uIndex != -1) {
      for (int i = 0; i < board.milestones.length; i++) {
        for (int j = 0; j < board.milestones[i].epics.length; j++) {
          board.milestones[i].epics[j].potentialUsers
              .removeWhere((id) => id == potentialUserId);
          for (int k = 0;
              k < board.milestones[i].epics[j].features!.length;
              k++) {
            for (int l = 0;
                l < board.milestones[i].epics[j].features![k].length;
                l++) {
              board.milestones[i].epics[j].features![k][l].potentialUsers
                  .removeWhere((id) => id == potentialUserId);
            }
          }
        }
      }

      board.potentialUsers
          .removeWhere((element) => element.id == potentialUserId);
      updateBoard(board);
      return;
    }

    throw Exception(
        "Could not find potential user with if ${potentialUserId} in database");
  }

  @override
  Future<List<PotentialUser>> getAvailablePotentialUsers(String boardId) async {
    Board board = await getBoardObject(boardId);

    return board.potentialUsers;
  }

  @override
  Future<void> updatePotentialUser(
      String boardId, PotentialUser potentialUser) async {
    Board board = await getBoardObject(boardId);

    if (board.potentialUsers.isEmpty) {
      board.potentialUsers.add(potentialUser);
      updateBoard(board);
      return;
    }

    int uIndex = board.potentialUsers
        .indexWhere((element) => element.id == potentialUser.id);

    if (uIndex == -1) {
      board.potentialUsers.add(potentialUser);
      updateBoard(board);
      return;
    }

    board.potentialUsers.removeAt(uIndex);
    board.potentialUsers.insert(uIndex, potentialUser);
    updateBoard(board);
  }

  @override
  Future<void> unvoteForEpic(
      String boardId, String milestoneId, String epicId) {
    // TODO: implement unvoteForEpic
    // Tip for implementation https://fireship.io/snippets/firestore-increment-tips/
    throw UnimplementedError();
  }

  @override
  Future<void> unvoteForStory(
      String boardId, String milestoneId, String epicId, String storyId) {
    // TODO: implement unvoteForStory
    // Tip for implementation https://fireship.io/snippets/firestore-increment-tips/
    throw UnimplementedError();
  }

  @override
  Future<void> voteForEpic(String boardId, String milestoneId, String epicId) {
    // TODO: implement voteForEpic
    // Tip for implementation https://fireship.io/snippets/firestore-increment-tips/
    throw UnimplementedError();
  }

  @override
  Future<void> voteForStory(
      String boardId, String milestoneId, String epicId, String storyId) {
    // TODO: implement voteForStory
    // Tip for implementation https://fireship.io/snippets/firestore-increment-tips/
    throw UnimplementedError();
  }
}
