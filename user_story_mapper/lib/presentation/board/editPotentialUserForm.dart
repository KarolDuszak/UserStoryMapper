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
  late Color pickerColor;

  _EditPotentialUser(String boardId, PotentialUser potentialUser) {
    this.potentialUser = potentialUser;
    this.boardId = boardId;
    description.text = potentialUser.description;
    name.text = potentialUser.name;
    pickerColor = Colors.red;
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
            /*ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      pickerColor as MaterialPropertyResolver<Color?>),
                ),
                onPressed: () {},
                child: Text("Selected Color")),*/
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      FirebaseBoardApi().updatePotentialUser(
                          boardId,
                          PotentialUser(
                              id: potentialUser.id,
                              color: potentialUser.color,
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
