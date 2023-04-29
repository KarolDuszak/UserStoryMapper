import 'package:drag_and_drop_lists/drag_and_drop_list_interface.dart';
import 'package:flutter/material.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:user_story_mapper/models/story.dart';
import 'package:user_story_mapper/models/feature.dart';
import 'package:user_story_mapper/presentation/board/storyCard.dart';

import '../../models/epic.dart';

class EpicList extends StatefulWidget {
  const EpicList({Key? key}) : super(key: key);

  @override
  State createState() => _EpicList();
}

class InnerList {
  String title;
  List<Story> stories;
  InnerList({required this.title, required this.stories});
}

class _EpicList extends State<EpicList> {
  late Epic _epic;

  @override
  void initState() {
    super.initState();

    _epic = Epic.getEmptyObj(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Story Board'),
      ),
      body: DragAndDropLists(
        children:
            List.generate(_epic.features.length, (index) => _buildList(index)),
        onItemReorder: _onItemReorder,
        onListReorder: _onListReorder,
        axis: Axis.horizontal,
        listWidth: 200,
        listDraggingWidth: 200,
        listDecoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        listPadding: const EdgeInsets.all(5.0),
      ),
    );
  }

  _buildList(int outerIndex) {
    var feature = _epic.features[outerIndex];
    return DragAndDropList(
      leftSide: const VerticalDivider(
        color: Colors.black,
        width: 1.5,
        thickness: 1.5,
      ),
      rightSide: const VerticalDivider(
        color: Colors.black,
        width: 1.5,
        thickness: 1.5,
      ),
      children: List.generate(feature.stories.length,
          (index) => _buildItem(feature.stories[index])),
    );
  }

  _buildItem(Story item) {
    return DragAndDropItem(
      child: Container(
        padding: EdgeInsets.all(10),
        child: StoryCard(
          storyData: item,
          color: Colors.amber[300],
        ),
      ),
    );
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      // = _epic[oldListIndex].stories[oldItemIndex];
      var movedItem =
          _epic.features[oldListIndex].stories.removeAt(oldItemIndex);
      _epic.features[newListIndex].stories.insert(newItemIndex, movedItem);
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = _epic.features.removeAt(oldListIndex);
      _epic.features.insert(newListIndex, movedList);
    });
  }
}
