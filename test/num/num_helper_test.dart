// Import the test package and Counter class
import 'package:ltogt_utils/src/num/num_helper.dart';
import 'package:test/test.dart';

void main() {
  group('toPrecision', () {
    test('4321.12345678, 3 => 4321.123', () async {
      final d = NumHelper.toPrecision(4321.12345678, 3);

      expect(d, equals(4321.123));
    });

    test('4321.5, 0 => 4322', () async {
      final d = NumHelper.toPrecision(4321.5, 0);

      expect(d, equals(4322));
    });

    test('99 -> 1000', () async {
      final s = NumHelper.paddedString(99, 1000);

      expect(s, matches("0099"));
    });

    test('THROW 999 -> 10', () async {
      void f() {
        final s = NumHelper.paddedString(999, 10);
      }

      expect(() => f(), throwsException);
    });
  });

  group('paddedString', () {
    test('0 -> 100', () async {
      final s = NumHelper.paddedString(0, 100);

      expect(s, matches("000"));
    });

    test('99 -> 1000', () async {
      final s = NumHelper.paddedString(99, 1000);

      expect(s, matches("0099"));
    });

    test('THROW 999 -> 10', () async {
      void f() {
        final s = NumHelper.paddedString(999, 10);
      }

      expect(() => f(), throwsException);
    });
  });
}
