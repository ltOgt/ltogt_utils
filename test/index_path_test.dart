import 'package:ltogt_utils/src/index_path.dart';
import 'package:test/test.dart';

void main() {
  group('IndexPathHelper', () {
    test('throws', () async {
      final data = [
        // 0
        [
          // 0.0
          [
            // 0.0.0
            [
              // 0.0.0.0
              [1]
            ]
          ],
          // 0.1
          [2]
        ],
        [],
      ];
      late List result;
      expect(
        () => result = IndexPathHelper.extract<List>(
          getNext: (current, i) => current == null ? data[i] : current[i] as List,
          indexPath: [0, 1],
        ),
        returnsNormally,
      );
      expect(result.first, 2);
      expect(
        () => result = IndexPathHelper.extract<List>(
          getNext: (current, i) => current == null ? data[i] : current[i] as List,
          indexPath: [0, 0, 0, 0],
        ),
        returnsNormally,
      );
      print("");
      expect(result.first, 1);
    });
    test('throws on empty index', () async {
      expect(
        () => IndexPathHelper.extract<dynamic>(
          getNext: (current, i) => current,
          indexPath: [],
        ),
        throwsA(isA()),
      );
    });

    test('throws on index out of range', () async {
      final l = [
        // 0
        [1]
      ];
      expect(
        () => IndexPathHelper.extract<dynamic>(
          getNext: (c, i) => c == null ? l[i] : c[i],
          indexPath: [0, 1],
        ),
        throwsA(isA()),
      );
    });
  });
}
