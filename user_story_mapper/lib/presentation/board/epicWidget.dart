import 'package:drag_and_drop_lists/drag_and_drop_list_interface.dart';
import 'package:flutter/material.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:user_story_mapper/data/implementations/FirebaseBoardApi.dart';
import 'package:user_story_mapper/models/potentialUser.dart';
import 'package:user_story_mapper/models/story.dart';
import 'package:user_story_mapper/presentation/board/storyCard.dart';
import '../../models/epic.dart';

class EpicList extends StatefulWidget {
  final Epic epic;
  final String boardId;
  final List<PotentialUser> potentialUsers;

  EpicList(
      {Key? key,
      required this.epic,
      required this.boardId,
      required this.potentialUsers})
      : super(key: key);

  @override
  State createState() => _EpicList();
}

class _EpicList extends State<EpicList> {
  late Epic _epic;
  late String _boardId;
  late List<PotentialUser> _potentialUsers;

  @override
  void initState() {
    super.initState();
    _epic = widget.epic;
    _boardId = widget.boardId;
    _potentialUsers = widget.potentialUsers;
  }

  @override
  Widget build(BuildContext context) {
    _epic = widget.epic;
    var featuresFactor = (_epic.features!.length.toDouble() + 1);
    if (featuresFactor < 2) {
      featuresFactor = 2;
    }
    return SizedBox(
      width: 233.5 * featuresFactor,
      height: _getLongestFeature().toDouble() * 170 + 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(15, 5, 15, 10),
            child: Row(
              children: [
                StoryCard.epic(widget.boardId, _epic, _potentialUsers),
                SizedBox(width: 30),
                ElevatedButton(onPressed: () {}, child: Text("Move Epic")),
                ElevatedButton(
                  onPressed: () {
                    FirebaseBoardApi().updateEpic(_boardId, _epic);
                  },
                  child: Text("Test api"),
                ),
              ],
            ),
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
                  showAddStoryDialog(context, _epic.features!.length);
                },
                child: Text("Add Story"))),
        children: [],
      ),
    );
    return list;
  }

  _buildList(int outerIndex) {
    var feature = _epic.features![outerIndex];
    List<DragAndDropItem> featureList = List.generate(
        feature.length, (index) => _buildItemFromStory(feature[index]));

    return DragAndDropList(
        footer: Container(
            alignment: Alignment.center,
            child: ElevatedButton(
                onPressed: () {
                  showAddStoryDialog(context, outerIndex);
                },
                child: Text("Add Story"))),
        header: Container(
            alignment: Alignment.center,
            child:
                ElevatedButton(onPressed: () {}, child: Text("Move feature"))),
        children: featureList);
  }

  _buildItemFromStory(Story item) {
    return DragAndDropItem(
      child: Container(
        padding: EdgeInsets.all(10),
        child: StoryCard.story(widget.boardId, _epic.id, item, _potentialUsers),
      ),
    );
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(
      () {
        var movedItem = _epic.features![oldListIndex].removeAt(oldItemIndex);

        //Add new feature if needed
        if (_epic.features!.length <= newListIndex) {
          _epic.features!.add([]);
        }
        _epic.features![newListIndex].insert(newItemIndex, movedItem);

        //Remove empty feature
        if (_epic.features![oldListIndex].isEmpty) {
          _epic.features?.removeAt(oldListIndex);
        }
        FirebaseBoardApi().updateEpic(_boardId, _epic);
      },
    );
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      if (newListIndex >= _epic.features!.length) {
        newListIndex = _epic.features!.length - 1;
      }
      var movedList = _epic.features?.removeAt(oldListIndex);
      _epic.features?.insert(newListIndex, movedList!);
      FirebaseBoardApi().updateEpic(_boardId, _epic);
    });
  }

  void _onListAdd(var draggableList, int listIndex) {
    setState(() {});
  }

  int _getLongestFeature() {
    int maxLen = 0;
    for (var feature in _epic.features!) {
      if (feature.length > maxLen) {
        maxLen = feature.length;
      }
    }
    return maxLen;
  }

  showAddStoryDialog(BuildContext context, int listIndex) {
    final description = TextEditingController();
    final title = TextEditingController();

    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      style: ElevatedButton.styleFrom(primary: Colors.red[700]),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget addButton = ElevatedButton(
      child: Text("Add"),
      style: ElevatedButton.styleFrom(primary: Colors.green[700]),
      onPressed: () {
        FirebaseBoardApi().createStory(_boardId, _epic.id, listIndex,
            Story.createStory(title.text, description.text));
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Add User Story to Epic ${_epic.title}"),
      content: Container(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(label: Text("Title")),
              controller: title,
            ),
            TextField(
              decoration: InputDecoration(label: Text("Description")),
              controller: description,
            )
          ],
        ),
      ),
      actions: [
        addButton,
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
