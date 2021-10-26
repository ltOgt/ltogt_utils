// Import the test package and Counter class
import 'package:ltogt_utils/ltogt_utils.dart';
import 'package:test/test.dart';

void main() {
  group('oneNotNull', () {
    test('should return false if more than one parameter is not null', () async {
      bool result = oneNotNull([null, 1, 2]);
      expect(result, equals(false));
    });

    test('should return false if all parameters are null', () async {
      bool result = oneNotNull([null, null, null, null]);
      expect(result, equals(false));
    });

    test('should return false if no parameters passed', () async {
      bool result = oneNotNull([]);
      expect(result, equals(false));
    });

    test('should return false if no parameter is null', () async {
      bool result = oneNotNull([1, "null", "Hey", true]);
      expect(result, equals(false));
    });

    test('should return true if exatly one parameter is not null', () async {
      bool result = oneNotNull([null, null, "Hey", null, null]);
      expect(result, equals(true));
    });
  });

  group('oneNull', () {
    test('should return true if one parameter is null', () async {
      bool result = oneNull([null, 1, 2]);
      expect(result, equals(true));
    });

    test('should return false if all parameters are null', () async {
      bool result = oneNull([null, null, null, null]);
      expect(result, equals(false));
    });

    test('should return false if no parameters passed', () async {
      bool result = oneNull([]);
      expect(result, equals(false));
    });

    test('should return false if no parameter is null', () async {
      bool result = oneNull([1, "null", "Hey", true]);
      expect(result, equals(false));
    });

    test('should return false if exatly one parameter is not null', () async {
      bool result = oneNull([null, null, "Hey", null, null]);
      expect(result, equals(false));
    });
  });

  group('noneNull', () {
    test('should return false if one parameter is null', () async {
      bool result = noneNull([null, 1, 2]);
      expect(result, equals(false));
    });

    test('should return false if all parameters are null', () async {
      bool result = noneNull([null, null, null, null]);
      expect(result, equals(false));
    });

    test('should return true if no parameters passed', () async {
      bool result = noneNull([]);
      expect(result, equals(true));
    });

    test('should return true if no parameter is null', () async {
      bool result = noneNull([1, "null", "Hey", true]);
      expect(result, equals(true));
    });
  });

  group('allNull', () {
    test('should return false if one parameter is null', () async {
      bool result = allNull([null, 1, 2]);
      expect(result, equals(false));
    });

    test('should return true if all parameters are null', () async {
      bool result = allNull([null, null, null, null]);
      expect(result, equals(true));
    });

    test('should return true if no parameters passed', () async {
      bool result = allNull([]);
      expect(result, equals(true));
    });

    test('should return false if no parameter is null', () async {
      bool result = allNull([1, "null", "Hey", true]);
      expect(result, equals(false));
    });
  });
}
