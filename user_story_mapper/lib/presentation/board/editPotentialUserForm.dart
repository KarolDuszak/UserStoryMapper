import 'package:flutter/material.dart';
import 'package:user_story_mapper/data/implementations/FirebaseBoardApi.dart';
import 'package:user_story_mapper/models/potentialUser.dart';

import '../../models/labelColor.dart';

class EditPotentialUser extends StatefulWidget {
  final PotentialUser potentialUser;
  final String boardId;

  const EditPotentialUser(
      {Key? key, required this.potentialUser, required this.boardId})
      : super(key: key);

  @override
  State createState() => _EditPotentialUser(boardId, potentialUser);
}

class _EditPotentialUser extends State<EditPotentialUser> {
  final _formKey = GlobalKey<FormState>();
  late final PotentialUser potentialUser;
  late final String boardId;

  final description = TextEditingController();
  final name = TextEditingController();
  //Jak z tego zrobić color picker?
  late ColorLabel pickerColor;

  _EditPotentialUser(String boardId, PotentialUser potentialUser) {
    this.potentialUser = potentialUser;
    this.boardId = boardId;
    description.text = potentialUser.description;
    name.text = potentialUser.name;
    pickerColor = potentialUser.color;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(5),
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                  hintText: "Provide potential user name", labelText: "Name"),
              controller: name,
            ),
            TextFormField(
              decoration: const InputDecoration(
                  hintText: "Describe who this potential user is",
                  labelText: "Description"),
              controller: description,
            ),
            DropdownButtonFormField<ColorLabel>(
              value: pickerColor,
              decoration: const InputDecoration(
                  labelText: "Color", hintText: "Select color"),
              onChanged: ((newValue) {
                setState(() {
                  pickerColor = newValue ?? ColorLabel.grey;
                });
              }),
              items: ColorLabel.values.map<DropdownMenuItem<ColorLabel>>(
                (ColorLabel color) {
                  return DropdownMenuItem<ColorLabel>(
                    value: color,
                    child: Text(
                      color.name,
                      style: TextStyle(
                          color: getColorFromLabel(color),
                          backgroundColor: Colors.white70),
                    ),
                  );
                },
              ).toList(),
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      FirebaseBoardApi().updatePotentialUser(
                          boardId,
                          PotentialUser(
                              id: potentialUser.id,
                              color: pickerColor,
                              name: name.text,
                              description: description.text));
                    },
                    child: Text("Save")),
                SizedBox(width: 5),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        description.text = potentialUser.description;
                        name.text = potentialUser.name;
                        pickerColor = potentialUser.color;
                      });
                    },
                    child: Text("Reset")),
                SizedBox(width: 5),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.red[700]),
                    onPressed: () {
                      FirebaseBoardApi()
                          .deletePotentialUser(boardId, potentialUser.id);
                    },
                    child: Text("Delete")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
