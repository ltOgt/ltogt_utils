import 'package:ltogt_utils/src/loop/iterator.dart';
import 'package:test/test.dart';

void main() {
  group('IndexedIterator', () {
    test('IndexedIterator itterates indexedly for List', () {
      final list = [0, 1, 2, 3, 4];
      for (final indexed in Indexed(list)) {
        expect(indexed.index == indexed.value, true);
      }
    });

    test('isEmpty does not change', () {
      final list = [0, 1, 2];
      final indexed = Indexed(list);
      expect(indexed.isEmpty, isFalse);
      expect(indexed.isEmpty, isFalse);
      expect(indexed.isEmpty, isFalse);
      expect(indexed.isEmpty, isFalse);
    });
  });

  group('DoubleIndexedIterator', () {
    test('DoubleIndexedIterator itterates for even List', () {
      final list = [0, 1, 2, 3, 4, 5];
      for (final di in DoubleIndexed(list)) {
        expect(di.index, di.value); // by design of the list values

        expect(di.value == list.first, di.isFirst);
        expect(di.value == list.last, di.isLast);

        expect(di.isMiddleExact, false);

        expect(di.value == 2 || di.value == 3, di.isMiddle);

        expect(di.value == 2, di.isMiddlePre);
        expect(di.value == 3, di.isMiddlePost);
      }
    });

    test('DoubleIndexedIterator itterates for odd List', () {
      final list = [0, 1, 2, 3, 4, 5, 6];
      for (final di in DoubleIndexed(list)) {
        expect(di.index, di.value); // by design of the list values

        expect(di.value == list.first, di.isFirst);
        expect(di.value == list.last, di.isLast);

        expect(di.isMiddlePre, false);
        expect(di.isMiddlePost, false);

        expect(di.value == 3, di.isMiddle);
        expect(di.value == 3, di.isMiddleExact);
      }
    });

    test('isEmpty does not change', () {
      final list = [0, 1, 2];
      final indexed = DoubleIndexed(list);
      expect(indexed.isEmpty, isFalse);
      expect(indexed.isEmpty, isFalse);
      expect(indexed.isEmpty, isFalse);
      expect(indexed.isEmpty, isFalse);
    });
  });

  group('Reversed', () {
    test('Reversed only', () {
      final list = ["x", "a", "b", "c", "x"];
      final expected = list.reversed;
      final actual = [];

      int lowest = 0;
      int skip = 0;

      for (final item in Reversed(list, skipEnd: lowest, skipStart: skip)) {
        actual.add(item);
      }
      expect(expected, equals(actual));
    });

    test('Skip', () {
      final list = ["x", "a", "b", "c", "x"];
      final expected = ["x", "a", "b", "c"].reversed;
      final actual = [];

      int lowest = 0;
      int skip = 1;

      for (final item in Reversed(list, skipEnd: lowest, skipStart: skip)) {
        actual.add(item);
      }
      expect(expected, equals(actual));
    });

    test('Lowest Index', () {
      final list = ["x", "a", "b", "c", "x"];
      final expected = ["a", "b", "c", "x"].reversed;
      final actual = [];

      int lowest = 1;

      for (final item in Reversed(list, skipEnd: lowest)) {
        actual.add(item);
      }
      expect(expected, equals(actual));
    });

    test('Lowest Index and Skip', () {
      final list = ["x", "a", "b", "c", "x"];
      final expected = ["a", "b", "c"].reversed;
      final actual = [];

      int lowest = 1;
      int skip = 1;

      for (final item in Reversed(list, skipEnd: lowest, skipStart: skip)) {
        actual.add(item);
      }
      expect(expected, equals(actual));
    });

    test('isEmpty does not change', () {
      final list = [0, 1, 2];
      final reversed = Reversed(list);
      expect(reversed.isEmpty, isFalse);
      expect(reversed.isEmpty, isFalse);
      expect(reversed.isEmpty, isFalse);
      expect(reversed.isEmpty, isFalse);
    });
  });
}
