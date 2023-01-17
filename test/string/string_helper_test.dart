import 'package:ltogt_utils/ltogt_utils.dart';
import 'package:test/test.dart';

void main() {
  group('StringHelper', () {
    group('char & int', () {
      test('nextChar', () async {
        //nextChar(String s, [int i = 1]) => charFromInt(charAsInt(s) + i);
        expect(StringHelper.nextChar("A"), "B");
        expect(StringHelper.nextChar("ABC"), "B");
        expect(StringHelper.nextChar("F"), "G");
        expect(StringHelper.nextChar("Z"), "[");

        expect(StringHelper.nextChar("A", 25), "Z");
        expect(StringHelper.nextChar("A", 0), "A");
        expect(StringHelper.nextChar("B", -1), "A");
      });

      test('charFromInt', () {
        //charFromInt(int i, [String? base]) => String.fromCharCode(i + (orNull(charAsInt(base!)) ?? 0));
        expect(StringHelper.charFromInt(65), "A");
        expect(StringHelper.charFromInt(66), "B");
        expect(StringHelper.charFromInt(90), "Z");
        expect(StringHelper.charFromInt(91), "[");

        expect(StringHelper.charFromInt(0, "A"), "A");
        expect(StringHelper.charFromInt(1, "A"), "B");
      });

      test('charAsInt', () {
        // charAsInt(String s) => s.codeUnits.first;
        expect(StringHelper.charAsInt("A"), 65);
        expect(StringHelper.charAsInt("ABC"), 65);
        expect(StringHelper.charAsInt("B"), 66);
        expect(StringHelper.charAsInt("Z"), 90);
        expect(StringHelper.charAsInt("["), 91);
      });
    });
  });
}
