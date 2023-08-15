import 'package:flutter/material.dart';
import 'package:user_story_mapper/models/boardModels/potentialUser.dart';

enum ColorLabel {
  green,
  purple,
  grey,
  blue,
  black,
}

Color? getColorFromPotentialUser(
    String id, List<PotentialUser> potentialUsers) {
  int uIndex = potentialUsers.indexWhere((element) => element.id == id);

  if (uIndex == -1) {
    return Colors.white;
  }

  var color = potentialUsers[uIndex].color;
  return getColorFromLabel(color);
}

Color? getColorFromLabel(ColorLabel label) {
  switch (label) {
    case ColorLabel.green:
      return Colors.green[500];
    case ColorLabel.purple:
      return Colors.purple;
    case ColorLabel.grey:
      return Colors.grey;
    case ColorLabel.blue:
      return Colors.blue;
    case ColorLabel.black:
      return Colors.black;
    default:
      return Colors.white;
  }
}
