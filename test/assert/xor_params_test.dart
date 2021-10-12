// Import the test package and Counter class
import 'package:ltogt_utils/ltogt_utils.dart';
import 'package:test/test.dart';

void main() {
  group('assert - xor params', () {
    test('should return false if more than one parameter is not null', () async {
      bool result = xorParams([null, 1, 2]);
      expect(result, equals(false));
    });

    test('should return false if all parameters are null', () async {
      bool result = xorParams([null, null, null, null]);
      expect(result, equals(false));
    });

    test('should return false if no parameters passed', () async {
      bool result = xorParams([]);
      expect(result, equals(false));
    });

    test('should return true if exatly one parameter is not null', () async {
      bool result = xorParams([null, null, "Hey", null, null]);
      expect(result, equals(true));
    });
  });
}
