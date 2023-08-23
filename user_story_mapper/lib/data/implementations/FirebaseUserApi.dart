import 'dart:async';

import 'package:user_story_mapper/data/interfaces/IUserApi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_story_mapper/models/userModels/boardInvitation.dart';
import 'package:user_story_mapper/models/userModels/user.dart';

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
  Future<List<BoardInvitation>> getUsersInvitations(String userId, String userEmail) async {
    CollectionReference inviteRef = FirebaseFirestore.instance.collection('boardInvitations');
    var snapshot = await inviteRef.doc(userId).collection('invitations').get();

    var data = snapshot.docs as List<Map<String, dynamic>>;
    return await List<BoardInvitation>.empty();
  }
}
