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
      return [BoardList.page("ffb2bc82-4e89-4f7d-a6d2-197d4e4bed9d")];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
  }
}
