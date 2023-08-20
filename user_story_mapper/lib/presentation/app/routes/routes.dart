import 'package:flutter/widgets.dart';
import 'package:user_story_mapper/presentation/app/bloc/app_bloc.dart';

import '../../board/boardWidget.dart';
import '../../login/view/loginPage.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.authenticated:
      return [BoardList.page("9e464b6f-8434-4003-8827-de33ea629dae")];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
  }
}
