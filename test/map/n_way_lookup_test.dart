// Import the test package and Counter class
import 'package:ltogt_utils/src/map/n_way_lookup.dart';
import 'package:test/test.dart';

void main() {
  group('Object', () {
    test('Should find correct object via every indexed field', () {
      Mapping m1 = Mapping(
        path: "method_one",
        requestType: Method1Request,
        responseType: Method1Response,
      );

      Mapping m2 = Mapping(
        path: "method_two",
        requestType: Method2Request,
        responseType: Method2Response,
      );

      NLookup<Mapping> target = NLookup<Mapping>(
        [m1, m2],
        [(m) => m.path, (m) => m.requestType, (m) => m.responseType],
      );

      expect(m1 == target.get(m1.path, 0), isTrue);
      expect(m1 == target.get(Method1Request, 1), isTrue);
      expect(m1 == target.get(Method1Response, 2), isTrue);
      expect(m2 == target.get(m2.path, 0), isTrue);
      expect(m2 == target.get(Method2Request, 1), isTrue);
      expect(m2 == target.get(Method2Response, 2), isTrue);
    });
  });

  group('Indexable', () {
    test('Should find correct object via every indexed field', () {
      IndexableMapping m1 = IndexableMapping(
        path: "method_one",
        requestType: Method1Request,
        responseType: Method1Response,
      );

      IndexableMapping m2 = IndexableMapping(
        path: "method_two",
        requestType: Method2Request,
        responseType: Method2Response,
      );

      NLookup<IndexableMapping> target = NLookup.indexable<IndexableMapping>(
        [m1, m2],
      );

      expect(m1 == target.get(m1.path, 0), isTrue);
      expect(m1 == target.get(Method1Request, 1), isTrue);
      expect(m1 == target.get(Method1Response, 2), isTrue);
      expect(m2 == target.get(m2.path, 0), isTrue);
      expect(m2 == target.get(Method2Request, 1), isTrue);
      expect(m2 == target.get(Method2Response, 2), isTrue);
    });
  });

  group('Generic Indexable', () {
    test('Should find correct object via every indexed field', () {
      final m1 = GenericIndexableMapping<Method1Request, Method1Response>(
        path: "method_one",
      );

      final m2 = GenericIndexableMapping<Method2Request, Method2Response>(
        path: "method_two",
      );

      NLookup<GenericIndexableMapping> target = NLookup.indexable<GenericIndexableMapping>(
        [m1, m2],
      );

      expect(m1 == target.get(m1.path, 0), isTrue);
      expect(m1 == target.get(Method1Request, 1), isTrue);
      expect(m1 == target.get(Method1Response, 2), isTrue);
      expect(m2 == target.get(m2.path, 0), isTrue);
      expect(m2 == target.get(Method2Request, 1), isTrue);
      expect(m2 == target.get(Method2Response, 2), isTrue);
    });
  });
}

// Example classes ===============================
abstract class Response {}

abstract class Request {}

class Method1Request extends Request {}

class Method1Response extends Response {}

class Method2Request extends Request {}

class Method2Response extends Response {}

class Mapping {
  final String path;
  final Type requestType;
  final Type responseType;

  Mapping({
    required this.path,
    required this.requestType,
    required this.responseType,
  });
}

class IndexableMapping extends Indexable {
  final String path;
  final Type requestType;
  final Type responseType;

  IndexableMapping({
    required this.path,
    required this.requestType,
    required this.responseType,
  });

  @override
  List<IndexValue> get indexes => [path, requestType, responseType];
}

class GenericIndexableMapping<REQ extends Request, RES extends Response> extends Indexable {
  final String path;
  Type get requestType => REQ;
  Type get responseType => RES;

  GenericIndexableMapping({
    required this.path,
  });

  @override
  List<IndexValue> get indexes => [path, REQ, RES];
}
