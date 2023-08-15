import 'dart:ui';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:user_story_mapper/models/boardModels/epic.dart';
import 'package:user_story_mapper/presentation/app/bloc_observer.dart';
import 'package:user_story_mapper/presentation/app/view/app.dart';
import 'package:user_story_mapper/presentation/board/epicWidget.dart';
import 'package:user_story_mapper/presentation/board/boardWidget.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;

  runApp(App(authenticationRepository: authenticationRepository));
}

/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ReorderableApp());
}

final GlobalKey _draggableKey = GlobalKey();

class ReorderableApp extends StatelessWidget {
  const ReorderableApp({super.key});

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drag and Drop Lists',
      initialRoute: '/milestone_example',
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      routes: {
        '/': (context) => Text("Here should be logging page"),
        '/milestone_example': (context) => const BoardList(),
      },
    );
  }
}
*/