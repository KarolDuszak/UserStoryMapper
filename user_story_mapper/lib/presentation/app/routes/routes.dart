import 'package:flutter/widgets.dart';
import 'package:user_story_mapper/presentation/app/bloc/app_bloc.dart';
import 'package:user_story_mapper/presentation/home/home.dart';
import '../../login/view/loginPage.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
  }
}
