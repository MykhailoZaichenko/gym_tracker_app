import 'package:intl/intl.dart';

class TimeUtils {
  static String formatRelativeTime(DateTime? date, String locale) {
    if (date == null) return locale == 'uk' ? "Давно" : "A long time ago";

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      final m = difference.inMinutes == 0 ? 1 : difference.inMinutes;
      return locale == 'uk' ? "$m хв тому" : "$m min ago";
    } else if (difference.inHours < 24) {
      return locale == 'uk'
          ? "${difference.inHours} год тому"
          : "${difference.inHours} hours ago";
    } else if (difference.inDays == 1) {
      return locale == 'uk' ? "Вчора" : "Yesterday";
    } else if (difference.inDays == 2) {
      return locale == 'uk' ? "2 дні тому" : "2 days ago";
    } else {
      return DateFormat.yMMMd(locale).format(date);
    }
  }
}
