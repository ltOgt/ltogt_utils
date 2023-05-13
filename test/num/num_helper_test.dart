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
        final _ = NumHelper.paddedString(999, 10);
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
        final _ = NumHelper.paddedString(999, 10);
      }

      expect(() => f(), throwsException);
    });
  });

  group('rescale', () {
    test('assertions for min max ordering', () {
      expect(
          () => NumHelper.rescale(
                value: 0,
                min: 1,
                max: 0,
                newMin: 0,
                newMax: 1,
              ),
          throwsA(isA<AssertionError>()));
      expect(
          () => NumHelper.rescale(
                value: 0,
                min: 0,
                max: 1,
                newMin: 1,
                newMax: 0,
              ),
          throwsA(isA<AssertionError>()));
    });

    test('(0,100) => (-1,1)', () async {
      double r(double v) => NumHelper.rescale(value: v, min: 0, max: 100, newMin: -1, newMax: 1);
      final min = r(0);
      final mid = r(50);
      final max = r(100);

      expect(min, equals(-1));
      expect(mid, equals(0));
      expect(max, equals(1));
    });

    test('(-1,1) => (-1.5,-.5)', () async {
      double r(double v) => NumHelper.rescale(value: v, min: -1, max: 1, newMin: -1.5, newMax: -.5);
      final min = r(-1);
      final mid = r(0);
      final max = r(1);

      expect(min, equals(-1.5));
      expect(mid, equals(-1));
      expect(max, equals(-.5));
    });

    test('(-10,10) => (0,20)', () async {
      double r(double v) => NumHelper.rescale(value: v, min: -10, max: 10, newMin: 0, newMax: 20);
      final min = r(-10);
      final mid = r(0);
      final max = r(10);

      expect(min, equals(0));
      expect(mid, equals(10));
      expect(max, equals(20));
    });
  });

  test('isBetween', () {
    expect(NumHelper.isBetween(100, 0, 100), isTrue);
    expect(NumHelper.isBetween(100, 0, 99), isFalse);
    expect(NumHelper.isBetween(-100, -100, 0), isTrue);
    expect(NumHelper.isBetween(-100, -99, 0), isFalse);
    expect(() => NumHelper.isBetween(0, 1, -1), throwsA(isA<AssertionError>()));
  });

  test('bounded', () {
    expect(NumHelper.bounded(-1, 0, 1), 0);
    expect(NumHelper.bounded(2, 0, 1), 1);
    expect(NumHelper.bounded(2, -10, -1), -1);
    expect(NumHelper.bounded(2, 100, 101), 100);
    expect(() => NumHelper.bounded(0, 1, -1), throwsA(isA<AssertionError>()));
  });
}
