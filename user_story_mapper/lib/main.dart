import 'package:flutter/material.dart';
import 'package:user_story_mapper/models/epic.dart';
import 'package:user_story_mapper/presentation/board/epicWidget.dart';
import 'package:user_story_mapper/presentation/board/boardWidget.dart';

void main() => runApp(const ReorderableApp());

final GlobalKey _draggableKey = GlobalKey();

class ReorderableApp extends StatelessWidget {
  const ReorderableApp({super.key});

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drag and Drop Lists',
      initialRoute: '/milestone_example',
      routes: {
        '/': (context) => EpicList(
              epic: Epic.getEmptyObj(2),
            ),
        '/milestone_example': (context) => const BoardList(),
      },
    );
  }
}
