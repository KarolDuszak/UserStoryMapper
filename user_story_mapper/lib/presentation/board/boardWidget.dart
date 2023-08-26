import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:user_story_mapper/models/boardModels/board.dart';
import 'package:user_story_mapper/models/boardModels/member.dart';
import 'package:user_story_mapper/models/boardModels/potentialUser.dart';
import 'package:user_story_mapper/models/userModels/boardInvitation.dart';
import 'package:user_story_mapper/presentation/board/editMemberForm.dart';
import 'package:user_story_mapper/presentation/board/epicWidget.dart';
import 'package:uuid/uuid.dart';
import '../../data/implementations/FirebaseBoardApi.dart';
import '../../models/boardModels/milestone.dart';
import '../../models/boardModels/epic.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_story_mapper/presentation/app/app.dart';

import '../app/routes/navMenu.dart';
import 'potentialUserPanelWidget.dart';

class BoardList extends StatefulWidget {
  const BoardList({Key? key, required this.boardId}) : super(key: key);

  final String boardId;

  static Page<void> page(String boardId) => MaterialPage<void>(
        child: BoardList(
          boardId: boardId,
        ),
      );

  @override
  State createState() => _BoardList();
}

class MenuOptions {
  static const String potentialUsers = 'Potential Users Menu';
  static const String manageMembers = 'Members Menu';
  static const String manageVoting = 'Voting Menu';

  static const List<String> choices = <String>[
    potentialUsers,
    manageMembers,
    manageVoting,
  ];
}

class _BoardList extends State<BoardList> {
  late Board _board;
  late Stream _boardStream;
  late dynamic user;

  @override
  void initState() {
    super.initState();
    _boardStream = FirebaseBoardApi().getBoard(widget.boardId);
  }

  @override
  Widget build(BuildContext context) {
    user = context.select((AppBloc bloc) => bloc.state.user);
    return MaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      home: Scaffold(
        drawer: NavMenu(),
        appBar: AppBar(title: const Center(child: Text("User Story Mapper"))),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: PopupMenuButton<String>(
          onSelected: choiceAction,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: const SizedBox(
              height: 50,
              width: 155,
              child: Row(children: [
                SizedBox(width: 3),
                Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                SizedBox(width: 3),
                Text(
                  "Board Settings",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )
              ]),
            ),
          ),
          itemBuilder: (BuildContext context) {
            return MenuOptions.choices.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
        body: StreamBuilder(
          key: Key("${Random().nextDouble()}"),
          stream: _boardStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _board = Board.fromJson(snapshot.data.data());
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: _board.milestones.length,
                      itemBuilder: (context, index) {
                        return Container(
                            decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide())),
                            child: _buildList(index, user.id));
                      },
                    ),
                  ),
                ],
              );
            }
            return Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  _buildList(int outerIndex, String userId) {
    var milestone = _board.milestones[outerIndex];
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: _getMaxHeightInMilestone()),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            color: const Color.fromARGB(255, 240, 242, 243),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: SizedBox(
                    width: 200,
                    child: Column(
                      children: [
                        AutoSizeText(
                          milestone.title,
                          style: const TextStyle(
                              fontSize: 36, fontWeight: FontWeight.bold),
                        ),
                        AutoSizeText(
                          milestone.description,
                          style: const TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  child: const Text("Edit Milestone"),
                  style: ElevatedButton.styleFrom(primary: Colors.green[700]),
                  onPressed: () async {
                    showEditMilestoneDialog(
                        context, _board.id, _board.milestones[outerIndex]);
                  },
                ),
                ElevatedButton(
                  child: const Text("Add New Epic"),
                  style: ElevatedButton.styleFrom(primary: Colors.red[700]),
                  onPressed: () {
                    showAddEpicDialog(context, outerIndex);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: milestone.epics.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                    decoration: const BoxDecoration(
                        border: Border(right: BorderSide())),
                    child: _buildItem(milestone.epics[index], userId));
              },
            ),
          ),
        ],
      ),
    );
  }

  showAddEpicDialog(BuildContext context, int milestoneIndex) {
    final description = TextEditingController();
    final title = TextEditingController();
    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      style: ElevatedButton.styleFrom(primary: Colors.red[700]),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget createButton = ElevatedButton(
      child: Text("Create"),
      style: ElevatedButton.styleFrom(primary: Colors.green[700]),
      onPressed: () {
        FirebaseBoardApi().createEpic(
          _board.id,
          milestoneIndex,
          Epic(
              id: Uuid().v4(),
              description: description.text,
              title: title.text,
              features: [],
              potentialUsers: [],
              votes: []),
        );
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Create new EPIC"),
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
        createButton,
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

  showEditPotentialUserDialog(BuildContext context) {
    List<PotentialUser> potUsers = _board.potentialUsers;

    Widget closeButton = ElevatedButton(
      child: Text("Close"),
      style: ElevatedButton.styleFrom(primary: Colors.red[700]),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget addButton = ElevatedButton(
      child: Text("Add"),
      style: ElevatedButton.styleFrom(primary: Colors.green[700]),
      onPressed: () {
        potUsers.add(PotentialUser.createNew());
        Navigator.of(context, rootNavigator: true).pop();
        showEditPotentialUserDialog(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Potential user menu"),
      content: PotentialUserPanel(_board.id, potUsers),
      actions: [
        addButton,
        closeButton,
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

  showManageMembersDialog(BuildContext context) {
    List<Member> memberList = _board.members;

    Widget closeButton = ElevatedButton(
      child: Text("Close"),
      
      style: ElevatedButton.styleFrom(primary: Colors.red[700]),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget addButton = ElevatedButton(
      child: Text("Add"),
      style: ElevatedButton.styleFrom(primary: Colors.green[700]),
      onPressed: () {
        memberList.add(Member(
            id: "",
            role: "Visitor",
            name: "",
            votesUsed: 0,
            invitationAccepted: false));
        Navigator.of(context, rootNavigator: true).pop();
        showManageMembersDialog(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Members menu"),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: memberList.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Center(
                child: EditMemberForm(
              boardId: _board.id,
              member: memberList[index],
            ));
          },
        ),
      ),
      actions: [
        addButton,
        closeButton,
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

  void choiceAction(String choice) {
    if (choice == MenuOptions.potentialUsers) {
      showEditPotentialUserDialog(context);
    } else if (choice == MenuOptions.manageMembers) {
      showManageMembersDialog(context);
    } else if (choice == MenuOptions.manageVoting) {
      String userId = "g5xfMJRI7kbcZ0qVWzuE1QkdXl22";
      FirebaseBoardApi().cancelInvitation(userId, _board.id);
    }
  }

  _buildItem(Epic item, String userId) {
    return EpicList(
      epic: item,
      boardId: _board.id,
      potentialUsers: _board.potentialUsers,
      userId: userId,
    );
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedItem =
          _board.milestones[oldListIndex].epics.removeAt(oldItemIndex);
      _board.milestones[newListIndex].epics.insert(newItemIndex, movedItem);
      FirebaseBoardApi().updateBoard(_board);
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = _board.milestones.removeAt(oldListIndex);
      _board.milestones.insert(newListIndex, movedList);
    });
    FirebaseBoardApi().updateBoard(_board);
  }

  _getMaxHeightInMilestone() {
    var maxHeight = 0;
    for (var i = 0; i < _board.milestones.length; i++) {
      for (var j = 0; j < _board.milestones[i].epics.length; j++) {
        for (var k = 0;
            k < _board.milestones[i].epics[j].features!.length;
            k++) {
          var currentHeight = _board.milestones[i].epics[j].features![k].length;
          if (currentHeight > maxHeight) {
            maxHeight = currentHeight;
          }
        }
      }
    }
    return (maxHeight + 1) * 170 + 100;
  }
}

showEditMilestoneDialog(
    BuildContext context, String boardId, Milestone milestone) {
  final description = TextEditingController();
  final title = TextEditingController();
  description.text = milestone.description;
  title.text = milestone.title;
  // set up the buttons
  Widget cancelButton = ElevatedButton(
    child: Text("Cancel"),
    style: ElevatedButton.styleFrom(primary: Colors.red[700]),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop();
    },
  );

  Widget addButton = ElevatedButton(
    child: Text("Save"),
    style: ElevatedButton.styleFrom(primary: Colors.green[700]),
    onPressed: () {
      FirebaseBoardApi().updateMilestoneProperties(
          boardId, milestone.id, title.text, description.text);
      Navigator.of(context, rootNavigator: true).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Edit Milestone ${milestone.title}"),
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
          ),
        ],
      ),
    ),
    actions: [
      addButton,
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
