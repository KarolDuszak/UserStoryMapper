import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:user_story_mapper/data/implementations/FirebaseBoardApi.dart';
import 'package:user_story_mapper/models/boardModels/potentialUser.dart';
import 'package:user_story_mapper/models/boardModels/story.dart';

class EditStoryForm extends StatefulWidget {
  late final Story currentCard;
  late final String boardId;
  late final String epicId;
  @override
  EditStoryFormState createState() =>
      EditStoryFormState(boardId, epicId, currentCard);

  EditStoryForm(String boardId, String epicId, Story story) {
    this.boardId = boardId;
    this.epicId = epicId;
    this.currentCard = story;
  }
}

class EditStoryFormState extends State<EditStoryForm> {
  final _formKey = GlobalKey<FormState>();
  late Story currentCard;
  late String boardId;
  late String epicId;
  List<PotentialUser> availableUsers = [];

  final description = TextEditingController();
  final title = TextEditingController();

  EditStoryFormState(String boardId, String epicId, Story order) {
    this.currentCard = order;
    this.boardId = boardId;
    this.epicId = epicId;
    description.text = currentCard.description;
    title.text = currentCard.title;
    FirebaseBoardApi().getAvailablePotentialUsers(boardId).then(
          (value) => setState(
            () {
              availableUsers = value;
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final _items = availableUsers
        .map((potUser) => MultiSelectItem<PotentialUser>(potUser, potUser.name))
        .toList();
    List<PotentialUser> selected =
        getPotentialUsersFromIds(availableUsers, currentCard.potentialUsers);
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("User Story", style: TextStyle(fontSize: 18.0)),
            TextFormField(
              decoration: new InputDecoration(
                icon: Icon(Icons.title),
                hintText: "Provide user story title",
                labelText: "Story Title",
              ),
              controller: title,
            ),
            TextFormField(
              controller: description,
              decoration: new InputDecoration(
                icon: Icon(Icons.business_outlined),
                hintText: "Provide user story description",
                labelText: "Description",
              ),
            ),
            MultiSelectDialogField<PotentialUser>(
              items: _items,
              initialValue: selected,
              title: Text("Potential Users"),
              buttonIcon: Icon(Icons.supervised_user_circle_rounded),
              buttonText: Text(
                "Select potential Users",
              ),
              onConfirm: (result) {
                selected = result;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  Story newCard = Story(
                      id: currentCard.id,
                      creatorId: currentCard.creatorId,
                      description: description.text,
                      title: title.text,
                      potentialUsers: selected.map((e) => e.id).toList(),
                      votes: currentCard.votes);

                  if (epicId != "") {
                    FirebaseBoardApi().updateStory(boardId, epicId, newCard);
                  } else {
                    FirebaseBoardApi().updateEpicProperties(boardId, newCard);
                  }
                },
                child: const Text("Confirm"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
