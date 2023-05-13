// Import the test package and Counter class
import 'package:ltogt_utils/src/list/list_generator.dart';
import 'package:test/test.dart';

void main() {
  group('List Generator', () {
    group('forEach', () {
      test('Should itterate for non-nullable', () async {
        List<int> l1 = [1, 2, 3];

        List<int> l2 = ListGenerator.forEach(list: l1, builder: (int v, int i) => v + i);

        expect(l2, equals([1, 3, 5]));
      });

      test('Should itterate for nullable', () async {
        List<int?> l1 = [1, 2, 3];

        List<int> l2 = ListGenerator.forEach(list: l1, builder: (int? v, int i) => v! + i);

        expect(l2, equals([1, 3, 5]));
      });
    });

    group('forRange', () {
      test('Should work for start at 0', () async {
        List<int> l = ListGenerator.forRange(from: 0, to: 3, generator: (int i) => i * 2);

        expect(l, equals([0, 2, 4]));
      });

      test('Should work for start at > 0', () async {
        List<int> l = ListGenerator.forRange(from: 3, to: 6, generator: (int i) => (i - 3) * 2);

        expect(l, equals([0, 2, 4]));
      });
    });

    group('seperated', () {
      test('Should intertwine', () async {
        List<String> l0 = ["a", "b", "c"];

        List<String> l = ListGenerator.seperated(
          list: l0,
          builder: (String e, int i) => "$e$i",
          seperator: "/",
        );

        expect(l.join(), equals("a0/b1/c2"));
      });
    });

    group('fromMap', () {
      test('Should work for non-nullable', () async {
        Map<int, int> m = {1: 1, 2: 2, 3: 3};

        List<int> l = ListGenerator.fromMap(map: m, builder: ((int k, int? v) => k + v!));

        expect(l, equals([2, 4, 6]));
      });
    });
  });
}
