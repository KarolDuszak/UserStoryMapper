import 'package:flutter/material.dart';
import 'package:user_story_mapper/models/comment.dart';
import 'package:user_story_mapper/models/potentialUser.dart';
import 'package:user_story_mapper/models/story.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../models/epic.dart';
import 'editStoryForm.dart';

class StoryCard extends StatefulWidget {
  final String id;
  final String title;
  final String description;
  final List<PotentialUser>? potentialUsers;
  final int votes;
  final Color? color;
  StoryCard(
      {Key? key,
      required this.id,
      required this.title,
      required this.description,
      required this.potentialUsers,
      required this.votes,
      required this.color})
      : super(key: key);

  StoryCard.epic(Epic epic, Color? color)
      : id = epic.id,
        title = epic.title,
        description = epic.description,
        potentialUsers = epic.potentialUsers,
        votes = epic.votes ?? 0,
        color = color;

  StoryCard.story(Story story, Color? color)
      : id = story.id,
        title = story.title,
        description = story.description,
        potentialUsers = story.potentialUsers,
        votes = story.votes ?? 0,
        color = color;

  @override
  State createState() => _StoryCard();
}

class _StoryCard extends State<StoryCard> {
  late String id;
  late String title;
  late String description;
  late List<PotentialUser>? potentialUsers;
  late int votes;
  late Color? color;
  late bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    title = widget.title;
    description = widget.description;
    color = widget.color;
    potentialUsers = widget.potentialUsers;
    votes = widget.votes;
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: () => print("b2 pressed"), child: Icon(Icons.save)),
            ElevatedButton(
                onPressed: () => print("b3 pressed"), child: Icon(Icons.delete))
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
        length, (i) => Icon(Icons.person, color: potentialUsers?[i].color));

    return Row(
        mainAxisAlignment: MainAxisAlignment.center, children: itemArray);
  }

  showEditStoryDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text("Anuluj"),
      style: ElevatedButton.styleFrom(primary: Colors.green[700]),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Edit User Story ${title}"),
      content: Container(
        child: EditStoryForm(
          Story(
              id: id,
              creatorId: "TO BE PASSED WHEN USERS WILL LOGIN",
              title: title,
              description: description,
              potentialUsers: potentialUsers,
              votes: votes,
              comments: Comment.getEmptyCommentObj()),
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
