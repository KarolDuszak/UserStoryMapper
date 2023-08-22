import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_story_mapper/data/implementations/FirebaseUserApi.dart';
import 'package:user_story_mapper/presentation/app/app.dart';
import 'package:user_story_mapper/presentation/board/boardWidget.dart';

import '../../../models/userModels/user.dart';
import '../../app/routes/navMenu.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.userId}) : super(key: key);

  final String userId;

  static Page<void> page(String userId) => MaterialPage<void>(
        child: ProfilePage(
          userId: userId,
        ),
      );

  @override
  State createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  final userName = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          userName.text = User.fromJson(data).name;
          return Scaffold(
            drawer: NavMenu(),
            appBar: AppBar(title: Center(child: Text("User Story Mapper"))),
            body: Align(
              alignment: const Alignment(0, -1 / 3),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                        hintText: "Provide potential user name",
                        labelText: "Name"),
                    controller: userName,
                  ),
                  const SizedBox(height: 4),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => BoardList(
                                boardId:
                                    "9e464b6f-8434-4003-8827-de33ea629dae")));
                      },
                      child: Text("Open board"))
                ],
              ),
            ),
          );
        }

        return Container(
            alignment: Alignment.center, child: CircularProgressIndicator());
      },
    );
  }
}
