import 'package:flutter/material.dart';

class KCOnstats {
  static const String themeModeKey = 'themeModeKey';
}

class KTextStyle {
  static const TextStyle titleTealTextStyle = TextStyle(
    color: Colors.teal,
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    letterSpacing: 2.0,
  );
  static const TextStyle descriptionTextStyle = TextStyle(fontSize: 16.0);
}

enum RangeMode { month, year }

enum ExitChoice { cancel, discard, save }

enum Weekday { monday, tuesday, wednesday, thursday, friday, saturday, sunday }
