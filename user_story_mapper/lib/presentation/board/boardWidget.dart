import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:user_story_mapper/models/board.dart';
import 'package:user_story_mapper/models/potentialUser.dart';
import 'package:user_story_mapper/presentation/board/epicWidget.dart';
import 'package:uuid/uuid.dart';
import '../../data/implementations/FirebaseBoardApi.dart';
import '../../models/milestone.dart';
import '../../models/epic.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:math';

class BoardList extends StatefulWidget {
  const BoardList({Key? key}) : super(key: key);

  @override
  State createState() => _BoardList();
}

class _BoardList extends State<BoardList> {
  //final Stream<Board> _boardStream =
  //    FirebaseBoardApi().getBoard("4437b74b-99c2-4b5b-b26a-e95b63f5b602");
  late Board _board;
  late Stream _boardStream;

  @override
  void initState() {
    super.initState();
    _boardStream =
        FirebaseBoardApi().getBoard("4437b74b-99c2-4b5b-b26a-e95b63f5b602");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.settings),
        label: const Text("Open Settings"),
        tooltip:
            "TODO: Add/Edit potentialUsers, members, roles, milestone, board data etc.",
        onPressed: () {
          print("Add Milestone");
          _board.milestones
              .add(Milestone.createNewMilestone("description", "title"));
          FirebaseBoardApi().updateBoard(_board);
        },
      ),
      body: StreamBuilder(
        key: Key("${Random().nextDouble()}"),
        stream: _boardStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _board = Board.fromJson(snapshot.data.data());
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: _board.milestones.length,
                    itemBuilder: (context, index) {
                      return Container(
                          decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide())),
                          child: _buildList(index));
                    },
                  ),
                ),
              ],
            );
          }
          return Container(
              alignment: Alignment.center, child: CircularProgressIndicator());
        },
      ),
    );
  }

  _buildList(int outerIndex) {
    var milestone = _board.milestones[outerIndex];
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: _getMaxHeightInMilestone()),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            color: const Color.fromARGB(255, 240, 242, 243),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: SizedBox(
                    width: 200,
                    child: Column(
                      children: [
                        AutoSizeText(
                          milestone.title,
                          style: const TextStyle(
                              fontSize: 36, fontWeight: FontWeight.bold),
                        ),
                        AutoSizeText(
                          milestone.description,
                          style: const TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //TODO: Implement edit milestone dialog where data can be modified
                ElevatedButton(
                  child: const Text("Edit Milestone"),
                  style: ElevatedButton.styleFrom(primary: Colors.green[700]),
                  onPressed: () async {},
                ),
                //TODO: Add new Epic to milestone
                ElevatedButton(
                  child: const Text("Add New Epic"),
                  style: ElevatedButton.styleFrom(primary: Colors.red[700]),
                  onPressed: () {
                    //print("Add PotentialUser Clicked");
                    //FirebaseBoardApi().createPotentialUser(
                    //  _board.id,
                    //  PotentialUser.getEmptyObj(),
                    //);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: milestone.epics.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                    decoration: const BoxDecoration(
                        border: Border(right: BorderSide())),
                    child: _buildItem(milestone.epics[index]));
              },
            ),
          ),
          //TODO: Add epic button
        ],
      ),
    );
  }

  _buildItem(Epic item) {
    return EpicList(epic: item, boardId: _board.id);
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      // = _epic[oldListIndex].stories[oldItemIndex];
      var movedItem =
          _board.milestones[oldListIndex].epics.removeAt(oldItemIndex);
      _board.milestones[newListIndex].epics.insert(newItemIndex, movedItem);
      FirebaseBoardApi().updateBoard(_board);
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = _board.milestones.removeAt(oldListIndex);
      _board.milestones.insert(newListIndex, movedList);
    });
    FirebaseBoardApi().updateBoard(_board);
  }

  _getMaxHeightInMilestone() {
    var maxHeight = 0;
    for (var i = 0; i < _board.milestones.length; i++) {
      for (var j = 0; j < _board.milestones[i].epics.length; j++) {
        for (var k = 0;
            k < _board.milestones[i].epics[j].features.length;
            k++) {
          var currentHeight = _board.milestones[i].epics[j].features[k].length;
          if (currentHeight > maxHeight) {
            maxHeight = currentHeight;
          }
        }
      }
    }
    return (maxHeight + 1) * 219 + 40;
  }
}
