import 'dart:async';
import 'dart:js_interop';

import 'package:user_story_mapper/data/implementations/FirebaseBoardApi.dart';
import 'package:user_story_mapper/data/interfaces/IUserApi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_story_mapper/models/userModels/boardData.dart';
import 'package:user_story_mapper/models/userModels/boardInvitation.dart';
import 'package:user_story_mapper/models/userModels/user.dart';

import '../../models/boardModels/board.dart';

class FirebaseUserApi extends IUserApi {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');

  @override
  Future<User> getUser(String userId) async {
    var snapshot = await userRef.doc(userId).get();

    var data = snapshot.data() as Map<String, dynamic>;
    return User.fromJson(data);
  }

  @override
  Future<void> createUser(User user) {
    return userRef
        .doc(user.id)
        .set(user.toJson())
        .then((value) => print("User created"))
        .onError((error, stackTrace) => print(error));
  }

  @override
  Future<void> deleteUser(String userId) {
    return userRef
        .doc(userId)
        .delete()
        .then((value) => print("Account successfully deleted"))
        .onError((error, stackTrace) => print(error));
  }

  @override
  Future<void> updateUser(User user) {
    return userRef
        .doc(user.id)
        .set(user.toJson())
        .then((value) => print("User ${user.id} updated"))
        .onError((error, stackTrace) => print(error));
  }

  @override
  Future<List<BoardInvitation>> getUsersInvitations(
      String userId, String userEmail) async {
    CollectionReference inviteRef =
        FirebaseFirestore.instance.collection('boardInvitations');
    var snapshot = await inviteRef.doc(userId).collection('invitations').get();

    if (snapshot.docs.isEmpty) {
      return await List<BoardInvitation>.empty();
    }

    var data = snapshot.docs;
    List<BoardInvitation> result = [];
    for (var x in data) {
      result.add(BoardInvitation.fromJson(x.data()));
    }
    return result;
  }

  @override
  Future<void> acceptBoardInvitation(String userId, String boardId) async {
    User user = await getUser(userId);
    Board board = await FirebaseBoardApi().getBoardObject(boardId);
    var i = board.members.indexWhere((element) => element.id == userId);
    board.members[i].invitationAccepted = true;
    user.boards.add(BoardData(
        boardId: boardId, name: board.title, description: board.description));

    FirebaseBoardApi().updateBoard(board);
    updateUser(user);
    deleteBoardInvitation(userId, boardId);
  }

  @override
  Future<void> declineBoardInvitation(String userId, String boardId) async {
    Board board = await FirebaseBoardApi().getBoardObject(boardId);
    board.members.removeWhere((element) => element.id == userId);
    FirebaseBoardApi().updateBoard(board);
    deleteBoardInvitation(userId, boardId);
  }

  @override
  Future<void> deleteBoardInvitation(String userId, String boardId) async {
    CollectionReference inviteRef =
        FirebaseFirestore.instance.collection('boardInvitations');
    return await inviteRef
        .doc(userId)
        .collection('invitations')
        .doc(boardId)
        .delete();
  }

  @override
  Future<void> addBoardToUser(String userId, Board board) async {
    User user = await getUser(userId);
    user.boards.add(BoardData(
        boardId: board.id, name: board.title, description: board.description));
    return await updateUser(user);
  }

  @override
  Future<void> addUserInvitation(BoardInvitation invitation) async {
    CollectionReference inviteRef =
        FirebaseFirestore.instance.collection('boardInvitations');
    return await inviteRef
        .doc(invitation.reciever)
        .collection('invitations')
        .doc(invitation.id)
        .set(invitation.toJson());
  }
}
