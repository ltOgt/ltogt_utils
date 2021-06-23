/// Value that can be indexed by [NLookup].
/// Can be extracted
/// - from [Indexable] via [Indexable.indexes].
/// - from [ObjectContainingValuesToIndex] via [IndexExtractor]
typedef IndexValue = Object;

/// Object which is to be indexed by [NLookup].
typedef ObjectContainingValuesToIndex = Object;

/// Function to extract [IndexValue] from [ObjectContainingValuesToIndex].
typedef IndexExtractor<T extends ObjectContainingValuesToIndex> = IndexValue Function(T o);

/// Interface for classes that should be indexable by [NLookup.indexable].
abstract class Indexable {
  List<IndexValue> get indexes;
}

/// Allows to create multi-way associations between objects.
///
/// For `NLookup(List<T> objects, List<IndexExtractor<T>> extractors)`
/// - Constructs N = [extractors.length] maps for all desired [IndexValue]s from [ObjectContainingValuesToIndex].
///
/// For `NLookup.indexable(List<Indexable> indexables)`
/// - Constructs N = [Indexable.indexes.length] maps for all desired [IndexValue]s from [Indexable.indexes].
///
class NLookup<T extends ObjectContainingValuesToIndex> {
  /// List of maps for each desired [IndexValue] of [T].
  ///
  /// For `NLookup(List<T> objects, List<IndexExtractor<T>> extractors)`
  /// - The order of the maps is determined by the order of [extractors].
  ///
  /// For `NLookup.indexable(List<Indexable> indexables)`
  /// - The order of the maps is determined by the order of [Indexable.indexes].
  late final List<Map<IndexValue, T>> _nLookups;

  /// Create a map for each [IndexValue] as defined by [extractors].
  /// The map created from the `i`-th [extractor] can be accessed via [lookup]`(indexKey, i)`.
  NLookup(List<T> objects, List<IndexExtractor<T>> extractors) {
    assert(objects.isNotEmpty);

    _nLookups = [];

    for (int i = 0; i < extractors.length; i++) {
      _nLookups.add({
        for (final o in objects) extractors[i](o): o,
      });
    }
  }

  /// Create a map for each [IndexValue] as defined by [Indexable.indexes].
  /// The map created from the `i`-th [Indexable.indexes] can be accessed via [lookup]: `lookup(IndexValue indexKey, int i)`.
  static NLookup<T> indexable<T extends Indexable>(List<T> indexables) {
    assert(indexables.isNotEmpty);
    int numberOfIndexes = indexables.first.indexes.length;
    assert(indexables.every((i) => i.indexes.length == numberOfIndexes));

    final nLookups = <Map<IndexValue, T>>[];

    for (int i = 0; i < numberOfIndexes; i++) {
      nLookups.add({
        for (final idx in indexables) idx.indexes[i]: idx,
      });
    }

    return NLookup<T>._(nLookups);
  }

  /// Internal constructor used by NLookup.indexable
  NLookup._(List<Map<IndexValue, T>> nLookups) : _nLookups = nLookups;

  /// Lookup [T] based on [IndexValue]s.
  ///
  /// For `NLookup(List<T> objects, List<IndexExtractor<T>> extractors)`
  /// - The desired [IndexValue] must have been extracted via [extractors] in the constructor.
  /// - If [slot] is specified, the [IndexValue] will be assumed to have been extracted by [extractors]`[slot]`.
  ///
  /// For `NLookup.indexable(List<Indexable> indexables)`
  /// - The desired [IndexValue] must have been contained in [T.indexes].
  /// - If [slot] is specified, the [IndexValue] will be assumed to have been extracted from [T.indexes]`[slot]`.
  ///
  /// If no [slot] is specified, all N maps are checked.
  T? get(IndexValue indexKey, [int? slot]) {
    if (slot != null) {
      return _nLookups[slot][indexKey];
    }
    for (final lookup in _nLookups) {
      dynamic result = lookup[indexKey];
      if (result != null) return result;
    }
    return null;
  }
}
