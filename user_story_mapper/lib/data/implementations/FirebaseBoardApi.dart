import 'dart:async';

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
    //TODO: check if id exists in db if so then change its id

    return boardsRef
        .doc(board.id)
        .set(board.toJson())
        .then((value) => print("Board Created"));
  }

  @override
  Future<void> deleteBoard(String boardId) {
    // TODO: implement deleteBoard
    throw UnimplementedError();
  }

  @override
  Stream<Board> getBoard(String boardId) {
    // TODO: implement getBoard
    throw UnimplementedError();
  }

  @override
  Future<void> updateBoard(Board board) {
    // TODO: implement updateBoard
    throw UnimplementedError();
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
      String fromMilestoneId, String toMilestoneId) {
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
