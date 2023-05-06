import 'package:flutter/material.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:user_story_mapper/models/board.dart';
import 'package:user_story_mapper/presentation/board/epicWidget.dart';
import '../../models/milestone.dart';
import '../../models/epic.dart';

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: DragAndDropLists(
              children: List.generate(
                  _board.milestones.length, (index) => _buildList(index)),
              onItemReorder: _onItemReorder,
              onListReorder: _onListReorder,
              axis: Axis.horizontal,
              listWidth: 215 * 5 * 4,
              listDraggingWidth: 215 * 5 * 4,
              listPadding: const EdgeInsets.all(5.0),
            ),
          ),
        ],
      ),
    );
  }

  _buildList(int outerIndex) {
    var milestone = _board.milestones[outerIndex];
    return DragAndDropList(
      children: List.generate(
        _board.milestones.length,
        (index) => _buildItem(milestone.epics[index]),
      ),
    );
  }

  _buildItem(Epic item) {
    return DragAndDropItem(
      child:
          Container(padding: EdgeInsets.all(10), child: EpicList(epic: item)),
    );
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
}
