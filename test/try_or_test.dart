import 'package:ltogt_utils/ltogt_utils.dart';
import 'package:test/test.dart';

void main() {
  group('tryOr', () {
    test('returns result if no exception', () async {
      final expected = 1;
      final actual = tryOr(
        () => expected,
        2,
        useElse: null,
      );
      expect(actual, equals(expected));
    });

    test('returns elseThis if exception and no test', () async {
      final expected = 1;
      final actual = tryOr(
        () => throw 2,
        expected,
        useElse: null,
      );
      expect(actual, equals(expected));
    });

    test('rethrows if exception and test failing', () async {
      final expected = 1;
      final actual = () => tryOr(
            () => throw _SomeException(),
            expected,
            useElse: (_) => false,
          );

      expect(actual, throwsA(isA<_SomeException>()));
    });

    test('returns elseThis if exception and test ok', () async {
      final expected = 1;
      final actual = () => tryOr(
            () => throw _SomeException(),
            expected,
            useElse: (_) => true,
          );

      expect(actual, returnsNormally);
      expect(actual(), equals(expected));
    });

    test('should pass exception to useElse', () async {
      final expected = 1;
      tryOr(
        () => throw _SomeException(),
        expected,
        useElse: (e) {
          expect(e, isA<_SomeException>());
          return true;
        },
      );
    });
  });
}

class _SomeException implements Exception {}
