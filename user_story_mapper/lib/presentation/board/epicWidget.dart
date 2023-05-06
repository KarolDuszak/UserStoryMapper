import 'package:flutter/material.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:user_story_mapper/models/story.dart';
import 'package:user_story_mapper/presentation/board/storyCard.dart';
import '../../models/epic.dart';

class EpicList extends StatefulWidget {
  final Epic epic;

  EpicList({Key? key, required this.epic}) : super(key: key);

  @override
  State createState() => _EpicList();
}

class _EpicList extends State<EpicList> {
  late Epic _epic;

  @override
  void initState() {
    super.initState();

    _epic = widget.epic;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 215 * _epic.features.length.toDouble(),
      height: 180 * _getLongestFeature().toDouble() + 30,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(15, 5, 15, 10),
            child:
                StoryCard(storyData: Story.getEmptyObj2(), color: Colors.red),
          ),
          Expanded(
            child: DragAndDropLists(
              children: List.generate(
                  _epic.features.length, (index) => _buildList(index)),
              onItemReorder: _onItemReorder,
              onListReorder: _onListReorder,
              axis: Axis.horizontal,
              listWidth: 215,
              listDraggingWidth: 215,
              listPadding: const EdgeInsets.all(5.0),
            ),
          ),
        ],
      ),
    );
  }

  _buildList(int outerIndex) {
    var feature = _epic.features[outerIndex];
    return DragAndDropList(
        leftSide: const VerticalDivider(
          color: Colors.black,
          width: 1.5,
          thickness: 1,
        ),
        footer: Container(
            alignment: Alignment.center,
            child: ElevatedButton(onPressed: () {}, child: Text("Add Story"))),
        children: List.generate(
          feature.stories.length,
          (index) => _buildItem(feature.stories[index]),
        ));
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

  int _getLongestFeature() {
    int maxLen = 0;
    for (var feature in _epic.features) {
      if (feature.stories.length > maxLen) {
        maxLen = feature.stories.length;
      }
    }
    return maxLen;
  }
}
