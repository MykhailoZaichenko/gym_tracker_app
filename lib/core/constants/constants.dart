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

List<String> ukrainianMonths = [
  'січень',
  'лютий',
  'березень',
  'квітень',
  'травень',
  'червень',
  'липень',
  'серпень',
  'вересень',
  'жовтень',
  'листопад',
  'грудень',
];

List<String> englishMonths = [
  '',
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String weekdayLabel(int weekday) {
  switch (weekday) {
    case DateTime.monday:
      return 'Понеділок';
    case DateTime.tuesday:
      return 'Вівторок';
    case DateTime.wednesday:
      return 'Середа';
    case DateTime.thursday:
      return 'Четвер';
    case DateTime.friday:
      return 'Пʼятниця';
    case DateTime.saturday:
      return 'Субота';
    case DateTime.sunday:
      return 'Неділя';
    default:
      return 'Понеділок';
  }
}

enum RangeMode { month, year }

enum ExitChoice { cancel, discard, save }

enum Weekday { monday, tuesday, wednesday, thursday, friday, saturday, sunday }
