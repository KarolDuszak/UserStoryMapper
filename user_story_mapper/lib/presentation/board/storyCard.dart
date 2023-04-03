import 'package:flutter/material.dart';
import 'package:user_story_mapper/models/potentialUser.dart';

class StoryCard extends StatelessWidget {
  const StoryCard(
      {super.key,
      this.title = '',
      this.description = '',
      this.votes = 0,
      this.potentialUser = const PotentialUser.constConstructor(
          "NULL", Colors.red, "NULL name", "NULL description")});
  final String title;
  final String description;
  final int votes;
  final PotentialUser potentialUser;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12.0,
      borderRadius: BorderRadius.circular(15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: SizedBox(
          width: 150,
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
                  child: Center(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 18.0,
                          ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              // TODO: Fix to display dinamically icons
                              for (var i = 0; i < 3; i++)
                                {Icon(Icons.person, color: potentialUser.color)}
                            ],
                          )),
                      SizedBox(
                          width: 50,
                          child: Text("+" + votes.toString(),
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
}
