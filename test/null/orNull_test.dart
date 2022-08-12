import 'package:ltogt_utils/src/null/orNull.dart';
import 'package:test/test.dart';

void main() {
  String? giveNull() => null;
  String? giveValue() => "Not Null";

  group('orNull', () {
    test('returns null given exception', () async {
      String? maybeNull = giveNull();
      int? length = orNull(() => maybeNull!.length);
      expect(length, equals(null));
    });
    test('returns result given no exception', () async {
      String? maybeNull = giveValue();
      int? length = orNull(() => maybeNull!.length);
      expect(length, equals(8));
    });

    test('rethrows exception given exception and contradiction test', () async {
      expect(
        () => orNull(() => throw Exception(), test: (_) => false),
        throwsException,
      );
    });

    test('returns null given exception and tautology test', () async {
      expect(
        () => orNull(() => throw Exception(), test: (_) => true),
        returnsNormally,
      );
    });
  });
}
