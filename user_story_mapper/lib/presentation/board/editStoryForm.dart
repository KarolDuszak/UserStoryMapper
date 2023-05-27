import 'package:flutter/material.dart';
import 'package:user_story_mapper/models/potentialUser.dart';
import 'package:user_story_mapper/models/story.dart';

class EditStoryForm extends StatefulWidget {
  late Story currentStory;
  @override
  EditStoryFormState createState() => EditStoryFormState(currentStory);

  EditStoryForm(Story order) {
    this.currentStory = order;
  }
}

class EditStoryFormState extends State<EditStoryForm> {
  final _formKey = GlobalKey<FormState>();
  late Story currentStory;

  //Story
  final description = TextEditingController();
  final title = TextEditingController();
  final potentialUser = TextEditingController();

  EditStoryFormState(Story order) {
    this.currentStory = order;
    this.description.text = currentStory.description;
    this.title.text = currentStory.title;
    this.potentialUser.text = currentStory.potentialUsers![0].name;
  }

  Future<Story> getStory() async {
    return new Story(
        id: "ID should be generated as GUID",
        creatorId: "Prescribe creator id from context",
        description: description.text,
        title: description.text,
        potentialUsers:
            List.generate(2, (index) => PotentialUser.getEmptyObj()),
        votes: 0);
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
                  print(
                      "Implementation to add new story to existing epic and to database");
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
