import 'package:ltogt_utils/src/null/ifNotNull.dart';
import 'package:test/test.dart';

void main() {
  group('ifNotNull', () {
    test('returns null given null', () async {
      String? maybeNull = null;
      int? length = ifNotNull(maybeNull, (value) => value.length);
      expect(length, equals(null));
    });
    test('executes function given non null', () async {
      String? maybeNull = "Not Null";
      int? length = ifNotNull(maybeNull, (value) => value.length);
      expect(length, equals(8));
    });
  });
}
