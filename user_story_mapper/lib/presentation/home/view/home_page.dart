import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_story_mapper/presentation/app/app.dart';
import 'package:user_story_mapper/presentation/board/boardWidget.dart';

import '../../app/routes/navMenu.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Page<void> page() => const MaterialPage(child: HomePage());

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return Scaffold(
      drawer: NavMenu(),
      appBar: AppBar(title: Center(child: Text("User Story Mapper"))),
      body: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 4),
            Text(user.email ?? ''),
            const SizedBox(height: 4),
            Text(user.name ?? ''),
            const SizedBox(height: 4),
            Text(user.id ?? ''),
            const SizedBox(height: 4),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BoardList(
                          boardId: "9e464b6f-8434-4003-8827-de33ea629dae")));
                },
                child: Text("Open board"))
          ],
        ),
      ),
    );
  }
}
