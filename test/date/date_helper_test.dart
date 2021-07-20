// Import the test package and Counter class
import 'package:ltogt_utils/src/date/date_helper.dart';
import 'package:test/test.dart';

void main() {
  group('dateString', () {
    test('0001-01-01', () async {
      final s = DateHelper.dateString(DateTime(1, 1, 1));

      expect(s, matches("0001-01-01"));
    });

    test('9999-12-31', () async {
      final s = DateHelper.dateString(DateTime(9999, 12, 31));

      expect(s, matches("9999-12-31"));
    });
  });
}
