import 'package:test/test.dart';
import "package:ltogt_utils/ltogt_utils.dart";

void main() {
  group('putIfAbsentAsync', () {
    test('is present', () async {
      final key = "key";
      final oldValue = 5;
      final map = {key: oldValue};

      final newValue = 6;

      final actual = await map.putIfAbsentAsync(key, () async {
        await Future.delayed(Duration(milliseconds: 200));
        return newValue;
      });

      expect(actual, equals(oldValue));
    });

    test('is absent', () async {
      final key = "key";
      final map = {};

      final newValue = 6;

      final actual = await map.putIfAbsentAsync(key, () async {
        await Future.delayed(Duration(milliseconds: 200));
        return newValue;
      });

      expect(actual, equals(newValue));
    });
  });
}
