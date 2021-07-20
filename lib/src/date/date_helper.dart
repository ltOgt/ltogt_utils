import 'package:ltogt_utils/src/num/num_helper.dart';

class DateHelper {
  static String dateString(DateTime date) {
    final yyyy = NumHelper.paddedString(date.year, 9999);
    final mm = NumHelper.paddedString(date.month, 12);
    final dd = NumHelper.paddedString(date.day, 31);
    return "$yyyy-$mm-$dd";
  }
}
