import 'package:flutter/material.dart';
import 'package:user_story_mapper/data/implementations/FirebaseBoardApi.dart';
import 'package:user_story_mapper/models/potentialUser.dart';
import 'package:user_story_mapper/models/story.dart';

class EditStoryForm extends StatefulWidget {
  late Story currentStory;
  late String boardId;
  late String epicId;
  @override
  EditStoryFormState createState() =>
      EditStoryFormState(boardId, epicId, currentStory);

  EditStoryForm(String boardId, String epicId, Story story) {
    this.boardId = boardId;
    this.epicId = epicId;
    this.currentStory = story;
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
  final potentialUser = TextEditingController();

  EditStoryFormState(String boardId, String epicId, Story order) {
    this.currentStory = order;
    this.boardId = boardId;
    this.epicId = epicId;
    this.description.text = currentStory.description;
    this.title.text = currentStory.title;
    if (currentStory.potentialUsers!.length > 0) {
      this.potentialUser.text = currentStory.potentialUsers[0];
    } else {
      this.potentialUser.text = "None";
    }
  }

  @override
  Widget build(BuildContext context) {
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
            TextFormField(
              controller: potentialUser,
              decoration: new InputDecoration(
                icon: Icon(Icons.euro_sharp),
                hintText: "Provide potential user",
                labelText: "Potential User",
              ),
            ),
            //TODO: Selecting potential user should work as multi select
            // dropdown list or multiple checkboxes

            /*DropdownButtonFormField<OrderStates>(
              value: orderStates,
              decoration: new InputDecoration(
                icon: Icon(Icons.stairs_outlined),
                hintText: "Status Zamówienia",
                labelText: "Status Zamówienia",
              ),
              onChanged: (newValue) {
                setState(() {
                  orderStates = newValue ?? OrderStates.newOrder;
                });
              },
              items: OrderStates.values.map((OrderStates val) {
                return DropdownMenuItem(
                  value: val,
                  child: Text(getTranslatedOrderStatus(val)),
                );
              }).toList(),
            ),*/

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  Story newStory = Story(
                      id: currentStory.id,
                      creatorId: currentStory.creatorId,
                      description: description.text,
                      title: title.text,
                      potentialUsers: currentStory.potentialUsers,
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
