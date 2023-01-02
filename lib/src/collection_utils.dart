abstract class CollectionUtils {
  Set<V> setAdd<V>(Set<V> current, V v) => {...current, v};
  Set<V> setRemove<V>(Set<V> current, V v) => {
        for (final c in current)
          if (c != v) //
            c
      };

  List<V> listAdd<V>(List<V> current, V v) => [...current, v];
  List<V> listRemove<V>(List<V> current, V v) => [
        for (final c in current)
          if (c != v) //
            c
      ];

  Map<K, V> mapAdd<K, V>(Map<K, V> current, K k, V v) => {...current, k: v};
  Map<K, V> mapRemove<K, V>(Map<K, V> current, K k) => {
        for (final c in current.entries)
          if (c.key != k) //
            c.key: c.value,
      };
}
