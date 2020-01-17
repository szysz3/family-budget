import 'package:date_util/date_util.dart';

class DateUtils {
  static DateTime getStartingDateForGivenWeek() {
    final date =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var weekDayNumber = date.weekday;
    return date.add(Duration(days: -(weekDayNumber - 1)));
  }

  static DateTime getEndingDateForGivenWeek() {
    final date =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var weekDayNumber = date.weekday;
    return date.add(Duration(days: 6 - (weekDayNumber - 1)));
  }

  static DateTime getStartingDateForGivenMonth(DateTime now) {
    return DateTime(now.year, now.month, 1);
  }

  static DateTime getEndingDateForGivenMonth(DateTime now) {
    var lastDayInMonth = DateUtil().daysInMonth(now.month, now.year);
    return DateTime(now.year, now.month, lastDayInMonth);
  }
}
