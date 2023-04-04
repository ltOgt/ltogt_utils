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
}
