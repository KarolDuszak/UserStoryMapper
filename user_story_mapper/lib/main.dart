import 'dart:ui';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:user_story_mapper/models/epic.dart';
import 'package:user_story_mapper/presentation/board/epicWidget.dart';
import 'package:user_story_mapper/presentation/board/boardWidget.dart';
import 'package:user_story_mapper/presentation/app.dart';

import 'firebase_options.dart';
import 'presentation/app/bloc/app_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authRepository = AuthenticationRepository();
  await authRepository.user.first;

  runApp(App(authenticationRepository: authRepository));
  //runApp(const ReorderableApp());
}

class App extends StatelessWidget {
  const App({
    required AuthenticationRepository authenticationRepository,
    super.key,
  }) : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: BlocProvider(
        create: (_) =>
            AppBloc(authenticationRepository: _authenticationRepository),
        child: const AppView(),
      ),
    );
  }
  
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }

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
        '/': (context) => EpicList(
              epic: Epic.getEmptyObj(2),
            ),
        '/milestone_example': (context) => const BoardList(),
      },
    );
  }
}
