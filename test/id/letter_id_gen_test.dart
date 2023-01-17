import 'package:ltogt_utils/src/id/letter_id.dart';
import 'package:ltogt_utils/src/loop/range.dart';
import 'package:test/test.dart';

void main() {
  test('LetterIdGen', () {
    final gen = LetterIdGen();
    expect(gen.current, "A");
    expect(gen.next(), "B");
    expect(gen.current, "B");
    for (final i in Range(23)) gen.next();
    expect(gen.next(), "AA");
  });
}
