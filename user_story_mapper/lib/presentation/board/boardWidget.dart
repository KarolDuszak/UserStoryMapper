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

class BoardList extends StatefulWidget {
  const BoardList({Key? key}) : super(key: key);

  @override
  State createState() => _BoardList();
}

class _BoardList extends State<BoardList> {
  //final Stream<Board> _boardStream =
  //    FirebaseBoardApi().getBoard("4437b74b-99c2-4b5b-b26a-e95b63f5b602");
  late Board _board;

  @override
  void initState() {
    super.initState();
    //var boardStream =
    //    FirebaseBoardApi().getBoard("4437b74b-99c2-4b5b-b26a-e95b63f5b602");

    //_board = Board.addNewBoard("creatorId", "title", "description");
    //FirebaseBoardApi().createBoard(_board);

    _board = Board.getEmptyObj(5);
  }

  @override
  Widget build(BuildContext context) {
    //return StreamBuilder<Board>(
    //  stream: _boardStream,
    //  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //    if (snapshot.hasError) {
    //      return Text('Something went wrong');
    //    }
//
    //    if (snapshot.connectionState == ConnectionState.waiting) {
    //      return Text("Loading");
    //    }

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.settings),
        label: Text("Open Settings"),
        tooltip: "Add Milestone",
        onPressed: () {
          print("Add Milestone");
          _board.milestones
              .add(Milestone.createNewMilestone("description", "title"));
          FirebaseBoardApi().updateBoard(_board);

          //TODO: Implement getBoard() method to recieve Stream to board
          //then add here simple update of board
          //_board = FirebaseBoardApi().getBoard(_board.id);
        },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _board.milestones.length,
              itemBuilder: (context, index) {
                return Container(
                    decoration:
                        BoxDecoration(border: Border(bottom: BorderSide())),
                    child: _buildList(index));
              },
            ),
          ),
        ],
      ),
    );
    //},
    //);
  }

  _buildList(int outerIndex) {
    var milestone = _board.milestones[outerIndex];
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: _getMaxHeightInMilestone()),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            color: Color.fromARGB(255, 240, 242, 243),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: SizedBox(
                    width: 200,
                    child: Column(
                      children: [
                        AutoSizeText(
                          milestone.title,
                          style: TextStyle(
                              fontSize: 36, fontWeight: FontWeight.bold),
                        ),
                        AutoSizeText(
                          milestone.description,
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //TODO: Implement edit milestone dialog where data can be modified
                ElevatedButton(
                  child: Text("Edit Milestone"),
                  style: ElevatedButton.styleFrom(primary: Colors.green[700]),
                  onPressed: () {
                    print("Edit Milestone");
                    FirebaseBoardApi().createBoard(_board);
                  },
                ),
                //TODO: Add potentialUser dialog where new potentialUser can be added
                ElevatedButton(
                  child: Text("Add Potential User"),
                  style: ElevatedButton.styleFrom(primary: Colors.red[700]),
                  onPressed: () {
                    print("Add PotentialUser Clicked");
                    FirebaseBoardApi().createPotentialUser(
                      _board.id,
                      PotentialUser.getEmptyObj(),
                    );
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
                    decoration:
                        BoxDecoration(border: Border(right: BorderSide())),
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
    return EpicList(epic: item);
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      // = _epic[oldListIndex].stories[oldItemIndex];
      var movedItem =
          _board.milestones[oldListIndex].epics.removeAt(oldItemIndex);
      _board.milestones[newListIndex].epics.insert(newItemIndex, movedItem);
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = _board.milestones.removeAt(oldListIndex);
      _board.milestones.insert(newListIndex, movedList);
    });
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
