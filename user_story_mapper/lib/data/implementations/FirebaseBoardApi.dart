import 'dart:async';
import 'dart:html';

import 'package:user_story_mapper/data/interfaces/IBoardApi.dart';
import 'package:user_story_mapper/models/board.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_story_mapper/models/epic.dart';
import 'package:user_story_mapper/models/potentialUser.dart';
import 'package:user_story_mapper/models/story.dart';

import '../../models/milestone.dart';

class FirebaseBoardApi extends IBoardApi {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference boardsRef =
      FirebaseFirestore.instance.collection('boards');

  final _loadedData = StreamController<Board>();

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
  Future<void> createPotentialUser(
      String boardId, PotentialUser potentialUser) {
    return boardsRef
        .doc(boardId)
        .collection("potentialUsers")
        .doc(potentialUser.id)
        .set(potentialUser.toJson())
        .then((value) => print("PotentialUser Created"));
  }

  @override
  Future<void> createEpic(String boardId, int milestoneIndex, Epic epic) {
    // TODO: implement createEpic
    throw UnimplementedError();
  }

  @override
  Future<void> updateEpic(String boardId, Epic epic) async {
    var snapshot = await boardsRef.doc(boardId).get();

    var data = snapshot.data() as Map<String, dynamic>;
    Board board = Board.fromJson(data);

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
    var snapshot = await boardsRef.doc(boardId).get();

    var data = snapshot.data() as Map<String, dynamic>;
    Board board = Board.fromJson(data);

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
            potentialUsers: prevEpic.potentialUsers,
            votes: prevEpic.votes);
        board.milestones[mIndex].epics.removeAt(index);
        board.milestones[mIndex].epics.insert(index, newEpic);
        updateBoard(board);
        return;
      }
    }

    throw Exception("Could not find epic to update");
  }

  @override
  Future<void> deleteEpic(String boardId, String epicId) {
    // TODO: implement deleteEpic
    throw UnimplementedError();
  }

  @override
  Future<void> createStory(
      String boardId, String epicId, int featureIndex, Story story) {
    // TODO: implement createStory
    throw UnimplementedError();
  }

  @override
  Future<void> updateStory(String boardId, String epicId, Story story) async {
    var snapshot = await boardsRef.doc(boardId).get();
    var data = snapshot.data() as Map<String, dynamic>;
    Board board = Board.fromJson(data);

    for (var m in board.milestones) {
      int eIndex = m.epics.indexWhere((element) => element.id == epicId);
      if (eIndex == -1) {
        continue;
      }

      int mIndex = board.milestones.indexWhere((element) => element.id == m.id);
      for (List<Story> feature
          in board.milestones[mIndex].epics[eIndex].features) {
        int sIndex = feature.indexWhere((element) => element.id == story.id);

        if (sIndex == -1) {
          continue;
        }
        int fIndex = board.milestones[mIndex].epics[eIndex].features
            .indexWhere((element) => element.first.id == feature.first.id);

        if (fIndex == -1) {
          throw Exception("For some reason feature not found");
        }

        board.milestones[mIndex].epics[eIndex].features[fIndex]
            .removeAt(sIndex);
        board.milestones[mIndex].epics[eIndex].features[fIndex]
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
    var snapshot = await boardsRef.doc(boardId).get();
    var data = snapshot.data() as Map<String, dynamic>;
    Board board = Board.fromJson(data);

    for (var m in board.milestones) {
      int eIndex = m.epics.indexWhere((element) => element.id == epicId);
      if (eIndex == -1) {
        continue;
      }

      int mIndex = board.milestones.indexWhere((element) => element.id == m.id);
      for (List<Story> feature
          in board.milestones[mIndex].epics[eIndex].features) {
        int sIndex = feature.indexWhere((element) => element.id == storyId);

        if (sIndex == -1) {
          continue;
        }
        int fIndex = board.milestones[mIndex].epics[eIndex].features
            .indexWhere((element) => element.first.id == feature.first.id);

        if (fIndex == -1) {
          throw Exception("For some reason feature not found");
        }

        board.milestones[mIndex].epics[eIndex].features[fIndex]
            .removeAt(sIndex);
        updateBoard(board);
        return;
      }
    }

    throw Exception("Could not find story to delete in database");
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
