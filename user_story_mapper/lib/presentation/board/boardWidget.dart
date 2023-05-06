import 'package:flutter/material.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:user_story_mapper/models/board.dart';
import 'package:user_story_mapper/presentation/board/epicWidget.dart';
import '../../models/milestone.dart';
import '../../models/epic.dart';
import 'package:auto_size_text/auto_size_text.dart';

class BoardList extends StatefulWidget {
  const BoardList({Key? key}) : super(key: key);

  @override
  State createState() => _BoardList();
}

class _BoardList extends State<BoardList> {
  late Board _board;

  @override
  void initState() {
    super.initState();

    _board = Board.getEmptyObj(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
  }

  _buildList(int outerIndex) {
    var milestone = _board.milestones[outerIndex];
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: _getMaxHeightInMilestone() * 1.2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: SizedBox(
                width: 200,
                child: Column(
                  children: [
                    AutoSizeText(
                      milestone.title,
                      style:
                          TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                    AutoSizeText(
                      milestone.description,
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: List.generate(
                milestone.epics.length,
                (index) => _buildItem(milestone.epics[index]),
              ),
            ),
          ),
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
        var currentHeight = _board.milestones[i].epics[j].features.length;
        if (currentHeight > maxHeight) {
          maxHeight = currentHeight;
        }
      }
    }
    return maxHeight * 180 + 30;
  }
}
