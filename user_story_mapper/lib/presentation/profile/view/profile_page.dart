import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_story_mapper/data/implementations/FirebaseUserApi.dart';
import 'package:user_story_mapper/models/userModels/boardInvitation.dart';
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
  late User user;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      key: const Key("user_profile"),
      future: FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          user = User.fromJson(data);
          userName.text = user.name;
          return Scaffold(
            drawer: NavMenu(),
            appBar: AppBar(title: Center(child: Text("User Story Mapper"))),
            body: Align(
              alignment: const Alignment(0, -4 / 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    width: 400,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      padding: const EdgeInsets.all(3),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          const Text("User Informations"),
                          const SizedBox(height: 8),
                          Text("Email Address: ${user.email}"),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("User Id: ${user.id}"),
                              const SizedBox(width: 4),
                              IconButton(
                                icon: const Icon(Icons.copy),
                                onPressed: () => {
                                  Clipboard.setData(
                                          ClipboardData(text: widget.userId))
                                      .then(
                                    (value) => ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text("Id copied to clipboard"),
                                      ),
                                    ),
                                  ),
                                },
                              )
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            decoration: const InputDecoration(
                                hintText: "Provide potential user name",
                                labelText: "User Name"),
                            controller: userName,
                          ),
                          const SizedBox(height: 4),
                          ElevatedButton(
                            onPressed: () {
                              FirebaseUserApi().updateUser(
                                User(
                                    id: user.id,
                                    email: user.email,
                                    name: userName.text,
                                    boards: user.boards),
                              );
                            },
                            child: const Text("Update Profile"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BoardList(
                              boardId: "9e464b6f-8434-4003-8827-de33ea629dae"),
                        ),
                      );
                    },
                    child: Text("Open board"),
                  ),
                  buildListView(),
                  /*Expanded(
                    child: !user.boards.isNull && user.boards!.isNotEmpty
                        ? ListView.builder(
                            itemCount: user.boards!.length,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: const BoxDecoration(
                                  border: Border(bottom: BorderSide()),
                                ),
                                child: _buildList(user.boards![index]),
                              );
                            },
                          )
                        : const Text("No board invitation found"),
                  ),*/
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

  Widget buildListView() {
    return FutureBuilder<List<BoardInvitation>>(
      key: const Key("invitations_list"),
      future: FirebaseUserApi().getUsersInvitations(widget.userId, ""),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<BoardInvitation>? data = snapshot.data;

          return Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: !data.isNull && data!.isNotEmpty ? data.length : 0,
              itemBuilder: (context, index) {
                return _buildList(data![index]);
              },
            ),
          );
        }
        return Container(
            alignment: Alignment.center, child: CircularProgressIndicator());
      },
    );
  }

  _buildList(BoardInvitation invitation) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            "Invitation Message: ${invitation.message}, Board Id: ${invitation.id}"),
        const SizedBox(width: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.green[700]),
          onPressed: () {
            setState(() {});
            //FirebaseUserApi().acceptBoardInvitation();
          },
          child: Text("Accept"),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.red[700]),
          onPressed: () {
            setState(() {});
          },
          child: Text("Decline"),
        ),
      ],
    );
  }
}
