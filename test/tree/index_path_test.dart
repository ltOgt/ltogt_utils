import 'package:ltogt_utils/src/tree/index_path.dart';
import 'package:test/test.dart';

void main() {
  group('IndexPathHelper', () {
    test('returns normally', () async {
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
      List<List> fillList = [];

      expect(
        () => result = IndexPathHelper.extract<List>(
          getNext: (current, i) => current == null ? data[i] : current[i] as List,
          indexPath: [0, 1],
          fillList: fillList,
        ),
        returnsNormally,
      );
      expect(result, data[0][1]);
      expect(fillList, [data[0], data[0][1]]);

      fillList = [];
      expect(
        () => result = IndexPathHelper.extract<List>(
          getNext: (current, i) => current == null ? data[i] : current[i] as List,
          indexPath: [0, 0, 0, 0],
          fillList: fillList,
        ),
        returnsNormally,
      );
      expect(result, data[0][0][0][0]);
      expect(fillList, [
        data[0],
        data[0][0],
        data[0][0][0],
        data[0][0][0][0],
      ]);
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
