import 'package:flutter/material.dart';
import 'package:user_story_mapper/models/potentialUser.dart';

import '../../models/labelColor.dart';

class EditPotentialUser extends StatefulWidget {
  final PotentialUser potentialUser;
  final String boardId;

  EditPotentialUser(
      {Key? key, required this.potentialUser, required this.boardId})
      : super(key: key);

  @override
  State createState() => _EditPotentialUser(boardId, potentialUser);
}

class _EditPotentialUser extends State<EditPotentialUser> {
  final _formKey = GlobalKey<FormState>();
  late PotentialUser potentialUser;
  late String boardId;

  final description = TextEditingController();
  final title = TextEditingController();
  //Jak z tego zrobić color picker?
  late Color pickerColor;

  _EditPotentialUser(String boardId, PotentialUser potentialUser) {
    potentialUser = potentialUser;
    boardId = boardId;
    description.text = potentialUser.description;
    title.text = potentialUser.name;
    pickerColor = getColorFromLabel(potentialUser.color)!;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(5),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          TextFormField(
            decoration: const InputDecoration(
                hintText: "Provide potential user name", labelText: "Name"),
            controller: title,
          ),
          TextFormField(
            decoration: const InputDecoration(
                hintText: "Describe who this potential user is",
                labelText: "Description"),
            controller: description,
          ),
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    pickerColor as MaterialPropertyResolver<Color?>),
              ),
              onPressed: () {},
              child: Text("Selected Color"))
        ],
      ),
    );
  }
}
