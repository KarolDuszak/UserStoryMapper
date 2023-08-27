import 'package:drag_and_drop_lists/drag_and_drop_list_interface.dart';
import 'package:flutter/material.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:user_story_mapper/data/implementations/FirebaseBoardApi.dart';
import 'package:user_story_mapper/models/boardModels/potentialUser.dart';
import 'package:user_story_mapper/models/boardModels/story.dart';
import 'package:user_story_mapper/presentation/board/storyCard.dart';
import '../../models/boardModels/board.dart';
import '../../models/boardModels/epic.dart';
import '../../utils/utils.dart';

class EpicList extends StatefulWidget {
  final Epic epic;
  final String userId;
  final String boardId;
  final List<PotentialUser> potentialUsers;

  EpicList(
      {Key? key,
      required this.epic,
      required this.boardId,
      required this.userId,
      required this.potentialUsers})
      : super(key: key);

  @override
  State createState() => _EpicList();
}

class _EpicList extends State<EpicList> {
  late Epic _epic;
  late String _boardId;
  late List<PotentialUser> _potentialUsers;
  late String _userId;

  @override
  void initState() {
    super.initState();
    _epic = widget.epic;
    _userId = widget.userId;
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
                StoryCard.epic(_boardId, _epic, _potentialUsers, _userId),
                SizedBox(width: 30),
                ElevatedButton(
                    onPressed: () {
                      showMoveEpicDialog(context, _boardId, _epic);
                    },
                    child: Text("Move Epic"))
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
                  showAddStoryDialog(context, _epic.id, _epic.features!.length);
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
                  showAddStoryDialog(context,_epic.id, outerIndex);
                },
                child: Text("Add Story"))),
        header: Container(
            alignment: Alignment.center,
            child: ElevatedButton(
                onPressed: () {
                  showMoveFeatureDialog(context, _boardId, _epic, outerIndex);
                },
                child: Text("Move feature"))),
        children: featureList);
  }

  _buildItemFromStory(Story item) {
    return DragAndDropItem(
      child: Container(
        padding: EdgeInsets.all(10),
        child: StoryCard.story(
            widget.boardId, _epic.id, item, _potentialUsers, widget.userId),
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

  showAddStoryDialog(BuildContext context, String epicId, int listIndex) async {
    final description = TextEditingController();
    final title = TextEditingController();
    List<PotentialUser> availableUsers = [];

    await FirebaseBoardApi().getAvailablePotentialUsers(_boardId).then(
          (value) => setState(
            () {
              availableUsers = value;
            },
          ),
        );

    final _items = availableUsers
        .map((potUser) => MultiSelectItem<PotentialUser>(potUser, potUser.name))
        .toList();
    List<PotentialUser> selected = [];
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      style: ElevatedButton.styleFrom(primary: Colors.red[700]),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    Widget addButton = ElevatedButton(
      child: Text("Add"),
      style: ElevatedButton.styleFrom(primary: Colors.green[700]),
      onPressed: () {
        FirebaseBoardApi().createStory(
            _boardId,
            epicId,
            listIndex,
            Story.createStory(title.text, description.text,
                selected.map((e) => e.id).toList(), _userId));
        Navigator.of(context, rootNavigator: true).pop();
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
            ),
            MultiSelectDialogField<PotentialUser>(
              items: _items,
              initialValue: selected,
              title: Text("Potential Users"),
              buttonIcon: Icon(Icons.supervised_user_circle_rounded),
              buttonText: Text(
                "Select potential Users",
              ),
              onConfirm: (result) {
                selected = result;
              },
            ),
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

  showMoveEpicDialog(BuildContext context, String boardId, Epic epic) async {
    Board board = await FirebaseBoardApi().getBoardObject(boardId);

    List<int> epicPosition = Util.getEpicPosition(board, epic.id);
    int milestoneSelect = epicPosition[0];
    int epicSelect = epicPosition[1];
    List<int> listEpics = List<int>.generate(
        board.milestones[milestoneSelect].epics.length, (i) => i);

    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text("Close"),
      style: ElevatedButton.styleFrom(primary: Colors.red[700]),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    Widget saveButton = ElevatedButton(
      child: Text("Save"),
      style: ElevatedButton.styleFrom(primary: Colors.green[700]),
      onPressed: () {
        FirebaseBoardApi()
            .moveEpic(boardId, _epic.id, milestoneSelect, epicSelect);
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Move Epic: ${epic.title}"),
      content: Column(
        children: [
          DropdownButtonFormField(
            value: milestoneSelect,
            decoration: const InputDecoration(
                labelText: "Milestone Position",
                hintText: "Select milestone index where epic should be moved"),
            onChanged: ((newValue) {
              setState(() {
                milestoneSelect = newValue!;
                epicSelect = board.milestones[milestoneSelect].epics.length;
                listEpics = List<int>.generate(
                    board.milestones[milestoneSelect].epics.length + 1,
                    (i) => i);
              });
            }),
            items: List<int>.generate(board.milestones.length, (index) => index)
                .toList()
                .map<DropdownMenuItem<int>>(
              (int mIndex) {
                return DropdownMenuItem<int>(
                  value: mIndex,
                  child: Text(
                    mIndex.toString(),
                  ),
                );
              },
            ).toList(),
          ),
          SizedBox(
            height: 5,
          ),
          ElevatedButton(
              onPressed: () => {
                    Navigator.of(context, rootNavigator: true).pop(),
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                                "Select position in milestone ${board.milestones[milestoneSelect].title}"),
                            content: Column(
                              children: [
                                DropdownButtonFormField(
                                  value: epicSelect,
                                  decoration: const InputDecoration(
                                      labelText: "Epic Position",
                                      hintText:
                                          "Select index where epic should be moved"),
                                  onChanged: ((newValue) {
                                    setState(() {
                                      epicSelect = newValue!;
                                    });
                                  }),
                                  items: listEpics.map<DropdownMenuItem<int>>(
                                    (int i) {
                                      return DropdownMenuItem<int>(
                                        value: i,
                                        child: Text(
                                          i.toString(),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ],
                            ),
                            actions: [saveButton, cancelButton],
                          );
                        }),
                  },
              child: Text("Next")),
        ],
      ),
      actions: [
        cancelButton,
      ],
    );
    // show the dialog
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showMoveFeatureDialog(
      BuildContext context, String boardId, Epic epic, int fIndex) async {
    Board board = await FirebaseBoardApi().getBoardObject(boardId);

    List<int> epicPosition = Util.getEpicPosition(board, epic.id);
    int milestoneSelect = epicPosition[0];
    int epicSelect = epicPosition[1];
    int featureSelect = fIndex;
    List<int> listEpics = List<int>.generate(
        board.milestones[milestoneSelect].epics.length, (i) => i);
    List<int> listFeatures = List<int>.generate(
        board.milestones[milestoneSelect].epics[epicSelect].features!.length,
        (i) => i);
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text("Close"),
      style: ElevatedButton.styleFrom(primary: Colors.red[700]),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    Widget saveButton = ElevatedButton(
      child: Text("Save"),
      style: ElevatedButton.styleFrom(primary: Colors.green[700]),
      onPressed: () {
        FirebaseBoardApi().moveFeature(boardId, _epic.id, fIndex,
            milestoneSelect, epicSelect, featureSelect);
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Move Feature"),
      content: Column(
        children: [
          DropdownButtonFormField(
            value: milestoneSelect,
            decoration: const InputDecoration(
                labelText: "Milestone Position",
                hintText:
                    "Select milestone index where feature should be moved"),
            onChanged: ((newValue) {
              setState(() {
                milestoneSelect = newValue!;
                epicSelect = 0;
                listEpics = List<int>.generate(
                    board.milestones[milestoneSelect].epics.length, (i) => i);
                featureSelect = board
                        .milestones[milestoneSelect].epics[0].features!.length +
                    1;
              });
            }),
            items: List<int>.generate(board.milestones.length, (index) => index)
                .toList()
                .map<DropdownMenuItem<int>>(
              (int mIndex) {
                return DropdownMenuItem<int>(
                  value: mIndex,
                  child: Text(
                    mIndex.toString(),
                  ),
                );
              },
            ).toList(),
          ),
          const SizedBox(
            height: 5,
          ),
          ElevatedButton(
              onPressed: () => {
                    Navigator.of(context, rootNavigator: true).pop(),
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                                "Select position in milestone ${board.milestones[milestoneSelect].title}"),
                            content: Column(
                              children: [
                                DropdownButtonFormField(
                                  value: epicSelect,
                                  decoration: const InputDecoration(
                                      labelText: "Epic Position",
                                      hintText:
                                          "Select index of epic where feature should be moved"),
                                  onChanged: ((newValue) {
                                    setState(() {
                                      epicSelect = newValue!;
                                      featureSelect = board
                                          .milestones[milestoneSelect]
                                          .epics[epicSelect]
                                          .features!
                                          .length;
                                      listFeatures = List<int>.generate(
                                          featureSelect + 1, (i) => i);
                                    });
                                  }),
                                  items: listEpics.map<DropdownMenuItem<int>>(
                                    (int i) {
                                      return DropdownMenuItem<int>(
                                        value: i,
                                        child: Text(
                                          i.toString(),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                ElevatedButton(
                                  onPressed: () => {
                                    Navigator.of(context).pop(),
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                                "Select position in epic ${board.milestones[milestoneSelect].epics[epicSelect].title}"),
                                            content: Column(
                                              children: [
                                                DropdownButtonFormField(
                                                  value: featureSelect,
                                                  decoration: const InputDecoration(
                                                      labelText:
                                                          "Feature Position",
                                                      hintText:
                                                          "Select index where feature should be moved"),
                                                  onChanged: ((newValue) {
                                                    setState(() {
                                                      featureSelect = newValue!;
                                                    });
                                                  }),
                                                  items: listFeatures.map<
                                                      DropdownMenuItem<int>>(
                                                    (int i) {
                                                      return DropdownMenuItem<
                                                          int>(
                                                        value: i,
                                                        child: Text(
                                                          i.toString(),
                                                        ),
                                                      );
                                                    },
                                                  ).toList(),
                                                )
                                              ],
                                            ),
                                            actions: [saveButton, cancelButton],
                                          );
                                        }),
                                  },
                                  child: Text("Next"),
                                )
                              ],
                            ),
                            actions: [saveButton, cancelButton],
                          );
                        }),
                  },
              child: Text("Next")),
        ],
      ),
      actions: [
        cancelButton,
      ],
    );
    // show the dialog
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
