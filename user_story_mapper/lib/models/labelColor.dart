import 'package:flutter/material.dart';

enum ColorLabel {
  green,
  purple,
  grey,
  blue,
  black,
}

Color? getColorFromLabel(ColorLabel? color) {
  switch (color) {
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
