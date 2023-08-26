import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_story_mapper/data/implementations/FirebaseBoardApi.dart';
import 'package:user_story_mapper/models/userModels/boardData.dart';
import 'package:user_story_mapper/presentation/app/app.dart';
import 'package:user_story_mapper/presentation/board/boardWidget.dart';

import '../../../data/implementations/FirebaseUserApi.dart';
import '../../../models/boardModels/board.dart';
import '../../../models/userModels/user.dart';
import '../../app/routes/navMenu.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  static Page<void> page() => const MaterialPage<void>(
        child: HomePage(),
      );

  @override
  State createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return FutureBuilder(
      key: const Key("userData_homeView"),
      future: FirebaseFirestore.instance.collection("users").doc(user.id).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          User user = User.fromJson(data);

          return Scaffold(
            drawer: NavMenu(),
            appBar: AppBar(title: Center(child: Text("User Story Mapper"))),
            body:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              buildListView(context, user),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: IconButton(
                  onPressed: () {
                    showCreateNewBoard(context, user.id);
                  },
                  icon: Icon(Icons.add),
                  color: Colors.white,
                ),
              )
            ]),
          );
        }
        return Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator());
      },
    );
  }

  Widget buildListView(BuildContext context, User user) {
    if (user.boards.isEmpty) {
      return const Center(child: Text("Boards not found"));
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: user.boards.length,
      itemBuilder: (context, index) {
        return _buildList(context, user, user.boards[index]);
      },
    );
  }

  _buildList(BuildContext context, User user, BoardData boardData) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              "Board name: ${boardData.name}, description: ${boardData.description}"),
          const SizedBox(width: 8),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        BoardList(boardId: boardData.boardId)));
              },
              child: const Text("Open board")),
          const SizedBox(width: 8),
          ElevatedButton(
              onPressed: () {
                showEditBoardData(context, user, boardData.boardId);
              },
              child: Icon(Icons.edit)),
        ],
      ),
    );
  }

  showEditBoardData(BuildContext context, User user, String boardId) {
    BoardData boardData =
        user.boards.firstWhere((element) => element.boardId == boardId);
    final description = TextEditingController();
    description.text = boardData.description;
    final title = TextEditingController();
    title.text = boardData.name;

    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      style: ElevatedButton.styleFrom(primary: Colors.red[700]),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget saveButton = ElevatedButton(
      child: Text("Save"),
      style: ElevatedButton.styleFrom(primary: Colors.green[700]),
      onPressed: () async {
        user.boards.removeWhere((element) => element.boardId == boardId);
        user.boards.add(BoardData(
            boardId: boardId, name: title.text, description: description.text));
        await FirebaseUserApi().updateUser(user);
        setState(() {});
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Edit board data"),
      content: Container(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(label: Text("Title")),
              controller: title,
            ),
            TextField(
              decoration: InputDecoration(label: Text("Description")),
              controller: description,
            )
          ],
        ),
      ),
      actions: [
        saveButton,
        cancelButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showCreateNewBoard(BuildContext context, String userId) {
    final description = TextEditingController();
    final title = TextEditingController();

    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      style: ElevatedButton.styleFrom(primary: Colors.red[700]),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget saveButton = ElevatedButton(
      child: Text("Create"),
      style: ElevatedButton.styleFrom(primary: Colors.green[700]),
      onPressed: () async {
        Board newBoard =
            Board.addNewBoard(userId, title.text, description.text);
        await FirebaseBoardApi().createBoard(newBoard);
        setState(() {});
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Create new board"),
      content: Container(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(label: Text("Title")),
              controller: title,
            ),
            TextField(
              decoration: InputDecoration(label: Text("Description")),
              controller: description,
            )
          ],
        ),
      ),
      actions: [
        saveButton,
        cancelButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
