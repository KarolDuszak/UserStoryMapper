import 'package:flutter/material.dart';
import 'package:user_story_mapper/models/potentialUser.dart';
import 'package:user_story_mapper/models/story.dart';
import 'package:auto_size_text/auto_size_text.dart';

class StoryCard extends StatefulWidget {
  final Story storyData;
  final Color? color;

  StoryCard({Key? key, required this.storyData, required this.color})
      : super(key: key);

  @override
  State createState() => _StoryCard();
}

class _StoryCard extends State<StoryCard> {
  late Story storyData;
  late Color? color;
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    storyData = widget.storyData;
    color = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12.0,
      borderRadius: BorderRadius.circular(15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: GestureDetector(
          onDoubleTap: () => setState(() => isEditMode = !isEditMode),
          child: isEditMode ? getEditModeCard() : getDefaultCard(),
        ),
      ),
    );
  }

  getEditModeCard() {
    return SizedBox(
      width: 180,
      height: 150,
      child: Container(
        color: color,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () => print("b1 pressed"), child: Icon(Icons.edit)),
            ElevatedButton(
                onPressed: () => print("b2 pressed"), child: Icon(Icons.save)),
            ElevatedButton(
                onPressed: () => print("b3 pressed"), child: Icon(Icons.delete))
          ],
        ),
      ),
    );
  }

  getDefaultCard() {
    return SizedBox(
      width: 180,
      height: 150,
      child: Container(
        color: color,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            AnimatedContainer(
              height: 120,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 7),
                child: Center(
                  child: AutoSizeText(
                    storyData.title,
                    style: TextStyle(fontSize: 30),
                    maxLines: 4,
                  ),
                ),
              ),
            ),
            SizedBox(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                      width: 140,
                      child: Row(
                        children: [
                          rowBuilder(storyData.potentialUsers?.length ?? 0)
                        ],
                      )),
                  SizedBox(
                      child: Text("+" + storyData.votes.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold)))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  rowBuilder(length) {
    if (length > 5) {
      length = 5;
    }
    var itemArray = List<Widget>.generate(length,
        (i) => Icon(Icons.person, color: storyData.potentialUsers?[i].color));

    return Row(
        mainAxisAlignment: MainAxisAlignment.center, children: itemArray);
  }
}
