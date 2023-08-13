import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:user_story_mapper/data/implementations/FirebaseBoardApi.dart';
import 'package:user_story_mapper/models/labelColor.dart';
import 'package:user_story_mapper/models/potentialUser.dart';
import 'package:user_story_mapper/models/story.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../models/epic.dart';
import 'editStoryForm.dart';

class StoryCard extends StatefulWidget {
  final String boardId;
  final String epicId;
  final String id;
  final String title;
  final String description;
  final List<String> potentialUsers;
  final int votes;
  final Color? color;
  final bool isEpic;
  final List<PotentialUser> availablePotUsers;

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
      required this.availablePotUsers})
      : super(key: Key(id));

  StoryCard.epic(
      String boardId, Epic epic, List<PotentialUser> availablePotUsers)
      : boardId = boardId,
        epicId = "",
        id = epic.id,
        title = epic.title,
        description = epic.description,
        potentialUsers = epic.potentialUsers,
        votes = epic.votes ?? 0,
        isEpic = true,
        availablePotUsers = availablePotUsers,
        color = Colors.red[500];

  StoryCard.story(String boardId, String epicId, Story story,
      List<PotentialUser> availablePotUsers)
      : boardId = boardId,
        epicId = epicId,
        id = story.id,
        title = story.title,
        description = story.description,
        potentialUsers = story.potentialUsers,
        votes = story.votes ?? 0,
        isEpic = false,
        availablePotUsers = availablePotUsers,
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
  late int votes;
  late Color? color;
  late bool isEpic;
  late bool isEditMode = false;

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
                //TO DO
                onPressed: () =>
                    print("b2 here vote option should be provided"),
                child: Icon(Icons.save)),
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
                        children: [rowBuilder(potentialUsers?.length ?? 0)],
                      )),
                  SizedBox(
                      child: Text("+" + votes.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold)))
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
            color: getColorFromLabel(potentialUsers[i], availablePotUsers)));

    return Row(
        mainAxisAlignment: MainAxisAlignment.center, children: itemArray);
  }

  showDeleteConfirmDialog(BuildContext context) {
    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      style: ElevatedButton.styleFrom(primary: Colors.green[700]),
      onPressed: () {
        isEditMode = false;
        Navigator.of(context).pop();
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
        isEditMode = false;
        Navigator.of(context).pop();
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
      child: Text("Cancel"),
      style: ElevatedButton.styleFrom(primary: Colors.green[700]),
      onPressed: () {
        Navigator.of(context).pop();
        isEditMode = false;
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
              votes: votes),
        ),
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
