import 'package:ltogt_utils/src/type/sealed_union.dart';
import 'package:test/test.dart';

void main() {
  group('SealedUnion<L,R>', () {
    test('left', () async {
      SealedUnion<int, String> su;

      su = SealedUnion.left(20);

      var r = su.resolve(
        onLeft: (v) {
          expect(v, 20);
          return 1.0;
        },
        onRight: (v) {
          expect(false, true);
          throw "";
        },
      );
      expect(r, 1.0);

      switch (su) {
        case SealedUnionLeft l:
          expect(l.value, 20);
        case SealedUnionRight():
          expect(false, true);
      }

      su = SealedUnion.right("20");

      r = su.resolve(
        onLeft: (v) {
          expect(false, true);
          throw "";
        },
        onRight: (v) {
          expect(v, "20");
          return 2.0;
        },
      );
      expect(r, 2.0);

      switch (su) {
        case SealedUnionLeft():
          expect(false, true);
        case SealedUnionRight r:
          expect(r.value, "20");
      }
    });
  });
}
