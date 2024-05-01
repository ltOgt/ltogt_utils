import 'package:ltogt_utils/ltogt_utils.dart';
import 'package:test/test.dart';

void main() {
  group('collect', () {
    final strs = ["0", "1", "2"];
    test('collects', () async {
      expect(
        strs.collect(0, (acc, ele) => acc + int.parse(ele)),
        3,
      );
    });
  });

  test('sublistSafe', () async {
    expect(
      [1, 2, 3].sublistSafe(-1, 4),
      [1, 2, 3],
    );
    expect(
      [1, 2, 3].sublistSafe(0, 1),
      [1],
    );
    expect(
      [1, 2, 3].sublistSafe(0, 3),
      [1, 2, 3],
    );
    expect(
      [1, 2, 3].sublistSafe(2, 3),
      [3],
    );
  });
}
