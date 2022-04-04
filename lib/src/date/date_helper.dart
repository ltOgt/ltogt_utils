import 'package:ltogt_utils/src/num/num_helper.dart';

class DateHelper {
  /// prints yyyy-mm-dd
  static String dateString(DateTime date) {
    final yyyy = NumHelper.paddedString(date.year, 9999);
    final mm = NumHelper.paddedString(date.month, 12);
    final dd = NumHelper.paddedString(date.day, 31);
    return "$yyyy-$mm-$dd";
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
}
