import 'package:flutter/material.dart';
import 'package:user_story_mapper/models/epic.dart';
import 'package:user_story_mapper/presentation/board/epicWidget.dart';

void main() => runApp(const ReorderableApp());

final GlobalKey _draggableKey = GlobalKey();

class ReorderableApp extends StatelessWidget {
  const ReorderableApp({super.key});

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drag and Drop Lists',
      initialRoute: '/',
      routes: {
        '/': (context) => EpicList(
              epic: Epic.getEmptyObj(2),
            ),
      },
    );
  }
}
