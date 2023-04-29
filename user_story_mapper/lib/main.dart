import 'package:flutter/material.dart';
import 'package:user_story_mapper/presentation/board/epicList.dart';

void main() => runApp(const ReorderableApp());

final GlobalKey _draggableKey = GlobalKey();

class ReorderableApp extends StatelessWidget {
  const ReorderableApp({super.key});

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drag and Drop Lists',
      initialRoute: '/',
      routes: {
        '/': (context) => const EpicList(),
      },
    );
  }
}
