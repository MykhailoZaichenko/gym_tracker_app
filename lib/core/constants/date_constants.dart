import 'package:firebase_auth/firebase_auth.dart';

class DateConstants {
  DateConstants._();

  static DateTime get appStartDate {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && user.metadata.creationTime != null) {
      final created = user.metadata.creationTime!;
      return DateTime(created.year, created.month - 1, 1);
    }
    return DateTime(2024, 1, 1);
  }

  static DateTime get now => DateTime.now();

  static DateTime get currentMonthStart {
    final n = now;
    return DateTime(n.year, n.month, 1);
  }

  static DateTime get appMaxDate {
    final n = now;
    return DateTime(n.year, n.month + 1, 0);
  }
}
