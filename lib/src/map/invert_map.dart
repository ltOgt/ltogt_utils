/// Inverts a 1:N map, i.e. a Map that maps each keys to a list of values
///
/// {"a": [1,2], "b": [2,3]} => {1: ["a"], 2: ["a", "b"], 3: ["b"]}
Map<V, List<K>> invertMap1N<K, V>(Map<K, List<V>> original) {
  Map<V, List<K>> inverted = {};

  for (final oKey in original.keys) {
    final oValueList = original[oKey]!;
    for (final oValue in oValueList) {
      // Create new list if not yet exists, otherwise get reference
      final iValueList = inverted.putIfAbsent(oValue, () => []);

      iValueList.add(oKey);
    }
  }

  return inverted;
}
