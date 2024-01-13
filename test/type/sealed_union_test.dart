import 'package:ltogt_utils/src/type/sealed_union.dart';
import 'package:test/test.dart';

void main() {
  group('SealedUnion<L,R>', () {
    test('left', () async {
      SealedUnion<int, String> su;

      su = SealedUnion.left(20);

      su.resolve(
        onLeft: (v) {
          expect(v, 20);
        },
        onRight: (v) {
          expect(false, true);
        },
      );

      switch (su) {
        case SealedUnionLeft l:
          expect(l.value, 20);
        case SealedUnionRight():
          expect(false, true);
      }

      su = SealedUnion.right("20");

      su.resolve(
        onLeft: (v) {
          expect(false, true);
        },
        onRight: (v) {
          expect(v, "20");
        },
      );

      switch (su) {
        case SealedUnionLeft():
          expect(false, true);
        case SealedUnionRight r:
          expect(r.value, "20");
      }
    });
  });
}
