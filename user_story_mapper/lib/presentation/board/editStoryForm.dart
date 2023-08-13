import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:user_story_mapper/data/implementations/FirebaseBoardApi.dart';
import 'package:user_story_mapper/models/potentialUser.dart';
import 'package:user_story_mapper/models/story.dart';
import 'package:multiselect/multiselect.dart';

class EditStoryForm extends StatefulWidget {
  late Story currentStory;
  late String boardId;
  late String epicId;
  late List<PotentialUser> availableUsers;
  @override
  EditStoryFormState createState() =>
      EditStoryFormState(boardId, epicId, currentStory, availableUsers);

  EditStoryForm(String boardId, String epicId, Story story,
      List<PotentialUser> availableUsers) {
    this.boardId = boardId;
    this.epicId = epicId;
    this.currentStory = story;
    this.availableUsers = availableUsers;
  }
}

class EditStoryFormState extends State<EditStoryForm> {
  final _formKey = GlobalKey<FormState>();
  late Story currentStory;
  late String boardId;
  late String epicId;

  //Story
  final description = TextEditingController();
  final title = TextEditingController();
  late List<PotentialUser> availableUsers = [];

  EditStoryFormState(String boardId, String epicId, Story order,
      List<PotentialUser> availableUsers) {
    this.currentStory = order;
    this.boardId = boardId;
    this.epicId = epicId;
    this.description.text = currentStory.description;
    this.title.text = currentStory.title;
    if (currentStory.potentialUsers!.length > 0) {
      this.availableUsers = availableUsers;
    } else {
      this.availableUsers = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    //List<PotentialUser> selected = [];
    final _items = availableUsers
        .map((potUser) => MultiSelectItem<PotentialUser>(potUser, potUser.name))
        .toList();
    List<PotentialUser> selected =
        getPotentialUsersFromIds(availableUsers, currentStory.potentialUsers);
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
                  Story newStory = Story(
                      id: currentStory.id,
                      creatorId: currentStory.creatorId,
                      description: description.text,
                      title: title.text,
                      potentialUsers: selected.map((e) => e.id).toList(),
                      votes: currentStory.votes);

                  if (epicId != "") {
                    FirebaseBoardApi().updateStory(boardId, epicId, newStory);
                  } else {
                    FirebaseBoardApi().updateEpicProperties(boardId, newStory);
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

List<PotentialUser> getPotentialUsersFromIds(
    List<PotentialUser> availablePotUsers, List<String> potentialUsers) {
  List<PotentialUser> result = [];
  for (String u in potentialUsers) {
    var user = availablePotUsers.firstWhere((element) => element.id == u);
    if (!user.isNull) {
      result.add(user);
    }
  }
  return result;
}
