import 'package:ltogt_utils/src/string/string_converter.dart';
import 'package:test/test.dart';

void main() {
  group('String Converter', () {
    test('List<int>', () {
      void _f(String s, List<int> i) {
        expect(s, equals(StringConverter.intListToString(i)));
        expect(i, equals(StringConverter.intListFromString(s)));
      }

      _f("1,2,3,4,5,6", [1, 2, 3, 4, 5, 6]);
      _f("12,4,9,34,0,12", [12, 4, 9, 34, 0, 12]);
      _f("-1,-2,-3,-4,-5,-6", [-1, -2, -3, -4, -5, -6]);
    });
  });
}
