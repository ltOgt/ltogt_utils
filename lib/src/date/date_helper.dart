import 'package:ltogt_utils/ltogt_utils.dart';
import 'package:ltogt_utils/src/num/num_helper.dart';

class DateHelper {
  /// prints yyyy-mm-dd
  static String dateString(DateTime date) {
    final yyyy = NumHelper.paddedString(date.year, 9999);
    final mm = NumHelper.paddedString(date.month, 12);
    final dd = NumHelper.paddedString(date.day, 31);
    return "$yyyy-$mm-$dd";
  }

  static String yyyymmdd(DateTime date, [String? seperator]) {
    final s = dateString(date);
    return seperator == null ? s : s.replaceAll("-", seperator);
  }

  /// prints yyyy-mm-dd hh:mm.ss
  static String dateTimeString(DateTime date) {
    final n = date;
    String _pad2(int i) => NumHelper.paddedString(i, 10);
    return "${n.year}-${_pad2(n.month)}-${_pad2(n.day)} ${_pad2(n.hour)}:${_pad2(n.minute)}.${_pad2(n.second)}";
  }

  /// prints yyyy-mm-dd hh:mm.ss for DateTime.now()
  static String nowString() {
    return dateTimeString(DateTime.now());
  }

  /// Encodes [date] as UTC yyyy-mm-dd
  static String encodeAsDateString(DateTime date) => dateString(date.toUtc());

  /// Back conversion from [DateHelper.encodeAsDateString]
  static DateTime decodeFromDateString(String dateString) {
    final components = dateString.split("-");
    if (components.length != 3) throw Exception("Invalid dateString: $dateString");

    final yearString = components[0];
    final monthString = components[1];
    final dayString = components[2];

    return DateTime(int.parse(yearString), int.parse(monthString), int.parse(dayString));
  }

  /// Encodes [dateTime] as UTC yyyy-mm-dd hh:mm.ss
  static String encodeAsDateTimeString(DateTime dateTime) => dateTimeString(dateTime.toUtc());

  /// Back conversion from [DateHelper.encodeAsDateTimeString]
  static DateTime decodeFromDateTimeString(String dateTimeString) {
    final components = dateTimeString.split("-");

    final yearString = components[0];
    final monthString = components[1];

    final dayAndTime = components[2].split(" ");

    final dayString = dayAndTime[0];
    final hourAndRest = dayAndTime[1].split(":");

    final hour = hourAndRest[0];
    final minuteAndSecond = hourAndRest[1].split(".");

    final minute = minuteAndSecond[0];
    final second = minuteAndSecond[1];

    return DateTime.utc(
      int.parse(yearString),
      int.parse(monthString),
      int.parse(dayString),
      int.parse(hour),
      int.parse(minute),
      int.parse(second),
    );
  }
}
