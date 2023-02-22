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

  group('ENCODE + DECODE', () {
    test('encode and decode date without time', () {
      final dates = [
        DateTime.utc(0001, 1, 1),
        DateTime.utc(1111, 1, 1),
        DateTime.utc(1234, 2, 3),
        DateTime.utc(4321, 12, 12),
      ];
      for (final date in dates) {
        final String encoded = DateHelper.encodeAsDateString(date);
        print(encoded);
        final DateTime decoded = DateHelper.decodeFromDateString(encoded);
        expect(decoded.year, date.year);
        expect(decoded.month, date.month);
        expect(decoded.day, date.day);
      }
    });

    test('encode and decode dateTime', () {
      final dates = [
        DateTime.utc(0001, 1, 1),
        DateTime.utc(1111, 1, 1),
        DateTime.utc(1234, 2, 3),
        DateTime.utc(4321, 12, 12),
        DateTime.utc(0001, 1, 1, 1, 2, 3),
        DateTime.utc(1111, 1, 1, 4, 5, 6),
        DateTime.utc(1234, 2, 3, 20, 21, 22),
        DateTime.utc(4321, 12, 12, 59, 58, 57),
      ];
      for (final date in dates) {
        final String encoded = DateHelper.encodeAsDateTimeString(date);
        print(encoded);
        final DateTime decoded = DateHelper.decodeFromDateTimeString(encoded);
        expect(decoded, date);
      }
    });
  });
}
