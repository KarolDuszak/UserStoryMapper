import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_story_mapper/presentation/home/home.dart';

import '../bloc/app_bloc.dart';

class NavMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: Drawer(
        child: Container(
          color: Colors.blue,
          child: ListView(
            children: <Widget>[
              ListTile(
                title: const Text('Home'),
                textColor: Colors.white,
                trailing: const Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => HomePage())),
              ),
              ListTile(
                title: const Text('Profile'),
                textColor: Colors.white,
                trailing: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                onTap: () => {print("Navigate to profile")},
              ),
              ListTile(
                title: const Text("Log Out"),
                textColor: Colors.white,
                trailing: const Icon(Icons.logout, color: Colors.white),
                onTap: () {
                  context.read<AppBloc>().add(const AppLogoutRequested());
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
