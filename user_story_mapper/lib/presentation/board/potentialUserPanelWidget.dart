import 'package:flutter/material.dart';
import 'package:user_story_mapper/models/potentialUser.dart';

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
  late String boardId;
  late List<PotentialUser>? potentialUsers;

  PotentialUserPanelState(String boardId, List<PotentialUser>? potentialUsers) {
    this.boardId = boardId;
    this.potentialUsers = potentialUsers;
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError("");
  }
}
