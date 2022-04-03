import 'package:ltogt_utils/ltogt_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Range', () {
    test("0 to 100", () {
      List<int> expected = [
        for (int i = 0; i <= 100; i++) //
          i,
      ];
      List<int> actual = [
        for (int i in Range(100, min: 0)) //
          i,
      ];
      expect(actual, equals(expected));
    });

    test("100 to 0", () {
      List<int> expected = [
        for (int i = 100; i >= 0; i--) //
          i,
      ];
      List<int> actual = [
        for (int i in Range(100, min: 0, increment: false)) //
          i,
      ];
      expect(actual, equals(expected));
    });
  });
}
