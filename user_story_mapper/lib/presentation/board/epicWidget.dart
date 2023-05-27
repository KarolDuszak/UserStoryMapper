import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list_interface.dart';
import 'package:flutter/material.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:user_story_mapper/data/implementations/FirebaseBoardApi.dart';
import 'package:user_story_mapper/models/story.dart';
import 'package:user_story_mapper/presentation/board/storyCard.dart';
import '../../models/board.dart';
import '../../models/epic.dart';
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
    _epic = widget.epic;
    return SizedBox(
      width: 233.5 * (_epic.features.length.toDouble() + 1),
      height: 219 * _getLongestFeature().toDouble() + 40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(15, 5, 15, 10),
            child: Row(
              children: [
                StoryCard.epic(_epic),
                SizedBox(width: 30),
                ElevatedButton(onPressed: () {}, child: Text("Move Epic"))
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
                  showAddStoryDialog(context, _epic.features.length - 1);
                },
                child: Text("Add Story"))),
        children: [],
      ),
    );
    return list;
  }

  _buildList(int outerIndex) {
    var feature = _epic.features[outerIndex];
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
        child: StoryCard.story(item),
      ),
    );
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(
      () {
        var movedItem = _epic.features[oldListIndex].removeAt(oldItemIndex);

        //Add new feature if needed
        if (_epic.features.length <= newListIndex) {
          _epic.features.add([]);
        }
        _epic.features[newListIndex].insert(newItemIndex, movedItem);

        //Remove empty feature
        if (_epic.features[oldListIndex].isEmpty) {
          _epic.features.removeAt(oldListIndex);
        }
      },
    );
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = _epic.features.removeAt(oldListIndex);
      _epic.features.insert(newListIndex, movedList);
    });
  }

  void _onListAdd(var draggableList, int listIndex) {
    setState(() {});
  }

  int _getLongestFeature() {
    int maxLen = 0;
    for (var feature in _epic.features) {
      if (feature.length > maxLen) {
        maxLen = feature.length;
      }
    }
    return maxLen + 1;
  }

  showAddStoryDialog(BuildContext context, int listIndex) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      style: ElevatedButton.styleFrom(primary: Colors.red[700]),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    //TODO: Implement correct adding story mechanizm
    //It should add story at the end of epics
    //adds new story to Database
    Widget addButton = ElevatedButton(
      child: Text("Add"),
      style: ElevatedButton.styleFrom(primary: Colors.green[700]),
      onPressed: () {
        DateTime now = DateTime.now();
        FirebaseBoardApi().createBoard(
          Board(
            creatorId: "NULL",
            title: "NULL",
            id: "Test",
            milestones: [],
            description: "NULL",
            potentialUsers: [],
            roleLabels: [],
            members: [],
            votesNumber: 5,
            timer: DateTime(now.year, now.month, now.day, now.hour,
                now.minute + 5, now.second),
          ),
        );

        //var ref = FirebaseFirestore.instance.collection('test');
        //ref.doc("asdas3").set({
        //  "name": "Dumbbell curl",
        //  "muscle": "Biceps",
        //  "sets": {"reps": 10, "weight": 40}
        //}).then((value) => print("Board Created"));
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Add User Story to Epic ${_epic.title}"),
      content: Container(child: EditStoryForm(Story.getEmptyObj2())),
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
