import 'package:ltogt_utils/src/map/invert_map.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group("Invert 1:N map", () {
    test('Should invert map', () {
      final original = {
        "a": [1, 2],
        "b": [2, 3]
      };
      final expected = {
        1: ["a"],
        2: ["a", "b"],
        3: ["b"]
      };
      final actual = invertMap1N(original);

      expect(actual, equals(expected));
    });

    test('Should invert map back', () {
      final expected = {
        "a": [1, 2],
        "b": [2, 3]
      };
      final original = {
        1: ["a"],
        2: ["a", "b"],
        3: ["b"]
      };
      final actual = invertMap1N(original);

      expect(actual, equals(expected));
    });
  });
}
