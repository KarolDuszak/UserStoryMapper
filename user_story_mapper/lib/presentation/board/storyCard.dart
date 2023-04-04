import 'package:flutter/material.dart';
import 'package:user_story_mapper/models/potentialUser.dart';
import 'package:user_story_mapper/models/story.dart';
import 'package:auto_size_text/auto_size_text.dart';

class StoryCard extends StatelessWidget {
  StoryCard({super.key, required this.storyData});
  Story storyData;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12.0,
      borderRadius: BorderRadius.circular(15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: SizedBox(
          width: 180,
          height: 150,
          child: Container(
            color: Colors.amber[300],
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
                              // TODO: Fix to display dinamically icons
                              //for (var i = 0; i < 3; i++)
                              //{

                              //}
                              //Icon(Icons.person,
                              //  color: storyData.potentialUsers?[0].color)
                            ],
                          )),
                      SizedBox(
                          child: Text("+" + storyData.votes.toString(),
                              textAlign: TextAlign.center,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)))
                    ],
                  ),
                ),
              ],
            ),
          ),
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
