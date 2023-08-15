import 'package:flutter/material.dart';
import 'package:user_story_mapper/models/boardModels/potentialUser.dart';

import 'editPotentialUserForm.dart';

class PotentialUserPanel extends StatefulWidget {
  late final List<PotentialUser>? potentialUsers;
  late final String boardId;
  @override
  PotentialUserPanelState createState() =>
      PotentialUserPanelState(boardId, potentialUsers);

  PotentialUserPanel(String boardId, List<PotentialUser>? potentialUsers) {
    this.boardId = boardId;
    this.potentialUsers = potentialUsers;
  }
}

class PotentialUserPanelState extends State<PotentialUserPanel> {
  late final String boardId;
  late final List<PotentialUser>? potentialUsers;

  PotentialUserPanelState(String boardId, List<PotentialUser>? potentialUsers) {
    this.boardId = boardId;
    this.potentialUsers = potentialUsers;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: potentialUsers?.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return Center(
              child: EditPotentialUser(
            boardId: boardId,
            potentialUser: potentialUsers![index],
          ));
        },
      ),
    );
  }
}
