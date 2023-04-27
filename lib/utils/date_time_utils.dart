import 'package:intl/intl.dart';

class DateTimeUtils {
  static const String formatYearMonthDate = "yyyy-MM-dd";
  static const String formatDayMonthYear = "dd.MM.yyyy";
  static const String formatTime = "HH:mm:ss";

  static String fetchCurrentDate({String format = formatYearMonthDate}) {
    final now = DateTime.now();
    final formatter = DateFormat(format);
    return formatter.format(now);
  }

  static String changeDateFormat(String? date,
      {String inputFormat = formatYearMonthDate,
      String outFormat = formatDayMonthYear}) {
    try {
      if (date == null) {
        return "";
      }
      DateTime parseDate = DateFormat(inputFormat).parse(date);
      var inputDate = DateTime.parse(parseDate.toString());
      var outputFormat = DateFormat(outFormat);
      return outputFormat.format(inputDate);
    } catch (e) {
      return date ?? "";
    }
  }

  static String fetchCurrentTime({String format = formatTime}) {
    final now = DateTime.now();
    final formatter = DateFormat(format);
    return formatter.format(now);
  }
}
