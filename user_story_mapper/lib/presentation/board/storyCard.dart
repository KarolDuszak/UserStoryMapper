import 'package:flutter/material.dart';
import 'package:user_story_mapper/data/implementations/FirebaseBoardApi.dart';
import 'package:user_story_mapper/models/boardModels/labelColor.dart';
import 'package:user_story_mapper/models/boardModels/potentialUser.dart';
import 'package:user_story_mapper/models/boardModels/story.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../models/boardModels/epic.dart';
import 'editStoryForm.dart';

class StoryCard extends StatefulWidget {
  final String boardId;
  final String epicId;
  final String id;
  final String title;
  final String description;
  final List<String> potentialUsers;
  final List<String> votes;
  final Color? color;
  final bool isEpic;
  final List<PotentialUser> availablePotUsers;
  final String userId;

  StoryCard(
      {required this.boardId,
      required this.epicId,
      required this.id,
      required this.title,
      required this.description,
      required this.potentialUsers,
      required this.votes,
      required this.isEpic,
      required this.color,
      required this.availablePotUsers,
      required this.userId})
      : super(key: Key(id));

  StoryCard.epic(String boardId, Epic epic,
      List<PotentialUser> availablePotUsers, String userId)
      : boardId = boardId,
        epicId = "",
        id = epic.id,
        title = epic.title,
        description = epic.description,
        potentialUsers = epic.potentialUsers,
        votes = epic.votes,
        isEpic = true,
        availablePotUsers = availablePotUsers,
        userId = userId,
        color = Colors.red[500];

  StoryCard.story(String boardId, String epicId, Story story,
      List<PotentialUser> availablePotUsers, String user)
      : boardId = boardId,
        epicId = epicId,
        id = story.id,
        title = story.title,
        description = story.description,
        potentialUsers = story.potentialUsers,
        votes = story.votes,
        isEpic = false,
        availablePotUsers = availablePotUsers,
        userId = user,
        color = Colors.amber[300];

  @override
  State createState() => _StoryCard();
}

class _StoryCard extends State<StoryCard> {
  late String boardId;
  late String epicId;
  late String id;
  late String title;
  late String description;
  late List<String> potentialUsers;
  late List<PotentialUser> availablePotUsers;
  late List<String> votes;
  late Color? color;
  late bool isEpic;
  late bool isEditMode = false;
  late String userId;

  @override
  void initState() {
    super.initState();
    _setProperties();
  }

  _setProperties() {
    boardId = widget.boardId;
    epicId = widget.epicId;
    id = widget.id;
    title = widget.title;
    description = widget.description;
    color = widget.color;
    potentialUsers = widget.potentialUsers;
    votes = widget.votes;
    isEpic = widget.isEpic;
    availablePotUsers = widget.availablePotUsers;
    userId = widget.userId;
  }

  @override
  Widget build(BuildContext context) {
    _setProperties();
    return Material(
      elevation: 12.0,
      borderRadius: BorderRadius.circular(15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: GestureDetector(
          onDoubleTap: () => setState(() => isEditMode = !isEditMode),
          child: isEditMode ? getEditModeCard() : getDefaultCard(),
        ),
      ),
    );
  }

  getEditModeCard() {
    return SizedBox(
      width: 180,
      height: 150,
      child: Container(
        color: color,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () {
                  showEditStoryDialog(context);
                },
                child: Icon(Icons.edit)),
            ElevatedButton(
                onPressed: () {
                  showDeleteConfirmDialog(context);
                },
                child: Icon(Icons.delete))
          ],
        ),
      ),
    );
  }

  getDefaultCard() {
    ButtonStyle voteStyle = TextButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
      elevation: 0,
      textStyle: TextStyle(fontWeight: FontWeight.bold),
    );

    if (votes.contains(userId)) {
      voteStyle = TextButton.styleFrom(
        backgroundColor: Color.fromARGB(197, 1, 248, 236),
        foregroundColor: Colors.black,
        elevation: 0,
        textStyle: TextStyle(fontWeight: FontWeight.bold),
      );
    }
    return SizedBox(
      width: 180,
      height: 150,
      child: Container(
        color: color,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            AnimatedContainer(
              height: 120,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 7),
                child: Center(
                  child: AutoSizeText(
                    title,
                    style: TextStyle(fontSize: 30),
                    maxLines: 4,
                  ),
                ),
              ),
            ),
            SizedBox(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                      width: 140,
                      child: Row(
                        children: [rowBuilder(potentialUsers.length)],
                      )),
                  SizedBox(
                    height: 30,
                    width: 40,
                    child: TextButton(
                      onPressed: () {
                        if (isEpic) {
                          FirebaseBoardApi().voteForEpic(boardId, id, userId);
                        } else {
                          FirebaseBoardApi()
                              .voteForStory(boardId, epicId, id, userId);
                        }
                      },
                      style: voteStyle,
                      child: Text(
                        "+${votes.length}",
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  rowBuilder(length) {
    if (length > 5) {
      length = 5;
    }
    var itemArray = List<Widget>.generate(
        length,
        (i) => Icon(Icons.person,
            color: getColorFromPotentialUser(
                potentialUsers[i], availablePotUsers)));

    return Row(
        mainAxisAlignment: MainAxisAlignment.center, children: itemArray);
  }

  showDeleteConfirmDialog(BuildContext context) {
    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      style: ElevatedButton.styleFrom(primary: Colors.green[700]),
      onPressed: () {
        setState(() {
          isEditMode = false;
        });
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget deleteButton = ElevatedButton(
      child: Text("Delete"),
      style: ElevatedButton.styleFrom(primary: Colors.red[700]),
      onPressed: () {
        if (isEpic) {
          FirebaseBoardApi().deleteEpic(boardId, id);
        } else {
          FirebaseBoardApi().deleteStory(boardId, epicId, id);
        }
        setState(() {
          isEditMode = false;
        });
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    String alertText = "Are you sure you want to delete user story?";
    if (isEpic) {
      alertText = "Are you sure you want to delete EPIC?";
    }

    AlertDialog alert = AlertDialog(
      title: Text(alertText),
      content: Container(
        child: Text(title),
      ),
      actions: [
        deleteButton,
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

  showEditStoryDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text("Close"),
      style: ElevatedButton.styleFrom(primary: Colors.green[700]),
      onPressed: () {
        setState(() {
          isEditMode = false;
        });
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Edit User Story: ${title}"),
      content: Container(
        child: EditStoryForm(
            boardId,
            epicId,
            Story(
                id: id,
                creatorId: "TO BE PASSED WHEN USERS WILL LOGIN",
                title: title,
                description: description,
                potentialUsers: potentialUsers,
                votes: votes)),
      ),
      actions: [
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
