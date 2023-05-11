import 'package:drag_and_drop_lists/drag_and_drop_list_interface.dart';
import 'package:flutter/material.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:user_story_mapper/models/story.dart';
import 'package:user_story_mapper/presentation/board/storyCard.dart';
import '../../models/epic.dart';
import '../../models/feature.dart';
import 'editStoryForm.dart';

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
      width: 233.5 * (_epic.features.length.toDouble() + 1),
      height: 219 * _getLongestFeature().toDouble() + 40,
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
              children: _buildEpicList(_epic),
              onItemReorder: _onItemReorder,
              onListReorder: _onListReorder,
              onListAdd: _onListAdd,
              listDivider: const VerticalDivider(
                color: Colors.black,
                width: 1.5,
                thickness: 1,
              ),
              listDividerOnLastChild: false,
              axis: Axis.horizontal,
              disableScrolling: false,
              listWidth: 215,
              listDraggingWidth: 215,
              listPadding: const EdgeInsets.all(5.0),
            ),
          ),
        ],
      ),
    );
  }

  _buildEpicList(epic) {
    List<DragAndDropListInterface> list =
        List.generate(epic.features.length, (index) => _buildList(index));
    list.add(
      DragAndDropList(
        footer: Container(
            alignment: Alignment.center,
            child: ElevatedButton(
                onPressed: () {
                  showEditStoryDialog(context, _epic.features.length - 1);
                },
                child: Text("Add Story"))),
        children: [],
      ),
    );
    return list;
  }

  _buildList(int outerIndex) {
    var feature = _epic.features[outerIndex];
    return DragAndDropList(
        footer: Container(
            alignment: Alignment.center,
            child: ElevatedButton(
                onPressed: () {
                  showEditStoryDialog(context, outerIndex);
                },
                child: Text("Add Story"))),
        header: Container(
            alignment: Alignment.center,
            child:
                ElevatedButton(onPressed: () {}, child: Text("Move feature"))),
        children: List.generate(feature.stories.length,
            (index) => _buildItem(feature.stories[index])));
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
    setState(
      () {
        var movedItem =
            _epic.features[oldListIndex].stories.removeAt(oldItemIndex);
        if (_epic.features.length <= newListIndex) {
          _epic.features.add(_createFeatureFromStory(movedItem));
        }
        _epic.features[newListIndex].stories.insert(newItemIndex, movedItem);

        if (_epic.features[oldListIndex].stories.isEmpty) {
          final Feature feature = _epic.features.removeAt(oldListIndex);
        }
      },
    );
  }

  _createFeatureFromStory(Story story) {
    return Feature(
        id: story.id,
        description: story.description,
        title: story.title,
        stories: []);
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = _epic.features.removeAt(oldListIndex);
      _epic.features.insert(newListIndex, movedList);
    });
  }

  void _onListAdd(var draggableList, int listIndex) {
    setState(() {
      _epic.features.insert(listIndex, Feature.getEmptyObj(1));
    });
  }

  int _getLongestFeature() {
    int maxLen = 0;
    for (var feature in _epic.features) {
      if (feature.stories.length > maxLen) {
        maxLen = feature.stories.length;
      }
    }
    return maxLen + 1;
  }

  showEditStoryDialog(BuildContext context, int listIndex) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text("Anuluj"),
      style: ElevatedButton.styleFrom(primary: Colors.green[700]),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title:
          Text("Add User Story to Feature ${_epic.features[listIndex].title}"),
      content: Container(child: EditOrderForm(Story.getEmptyObj2())),
      actions: [
        cancelButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
