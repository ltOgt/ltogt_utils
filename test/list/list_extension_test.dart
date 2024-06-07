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

  test('copyWithChangedAtIndex', () async {
    expect(
      [1, 2, 3].copyWithChangedAtIndex(0, null),
      [2, 3],
    );
    expect(
      [1, 2, 3].copyWithChangedAtIndex(0, (_) => 10),
      [10, 2, 3],
    );
    expect(
      [1, 2, 3].copyWithChangedAtIndex(2, (_) => 10),
      [1, 2, 10],
    );
    expect(
      [1, 2, 3].copyWithChangedAtIndex(1, null),
      [1, 3],
    );
  });

  test('copyWithChanged', () async {
    expect(
      [1, 2, 3].copyWithChanged((_, __) => false, null),
      [1, 2, 3],
    );
    expect(
      [1, 2, 3].copyWithChanged((_, e) => e % 2 == 0, (_) => 10),
      [1, 10, 3],
    );
    expect(
      [1, 2, 3].copyWithChanged((i, _) => i < 2, (_) => 10),
      [10, 10, 3],
    );
    expect(
      [1, 2, 3].copyWithChanged((i, _) => i < 2, null),
      [3],
    );
  });
}
