import 'package:ltogt_utils/src/mutator.dart';
import 'package:test/test.dart';

void main() {
  group('maybeMutate', () {
    test('no function, use value', () {
      expect(maybeMutate(null, 1), 1);
    });
    test('function returns value, use that', () {
      expect(maybeMutate((_) => 2, 1), 2);
    });

    test('function returns null, use that', () {
      expect(maybeMutate<int?>((_) => null, 1), null);
    });
  });
}
