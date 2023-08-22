import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_story_mapper/presentation/home/home.dart';

import '../../login/view/loginPage.dart';
import '../../profile/view/profile_page.dart';
import '../bloc/app_bloc.dart';

class NavMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
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
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfilePage(userId: user.id))),
              ),
              ListTile(
                title: const Text("Log Out"),
                textColor: Colors.white,
                trailing: const Icon(Icons.logout, color: Colors.white),
                onTap: () {
                  context.read<AppBloc>().add(const AppLogoutRequested());
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
