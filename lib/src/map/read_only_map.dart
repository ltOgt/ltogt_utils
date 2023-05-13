// ignore_for_file: annotate_overrides

import 'dart:collection';

/// Basically the same as [UnmodifiableMapView], execpt
/// - shorter name
/// - short extension
/// - simper to read
/// - noticed the other option after writing all this, lol
final class ReadOnlyMap<K, V> implements Map<K, V> {
  late final Map<K, V> _map;

  ReadOnlyMap(Map<K, V> map) : _map = map;

  bool containsValue(Object? value) {
    assert(value is V);
    return _map.containsValue(value);
  }

  bool containsKey(Object? key) {
    assert(key is K);
    return _map.containsKey(key);
  }

  V? operator [](Object? key) {
    assert(key is K);
    return _map[key];
  }

  Iterable<MapEntry<K, V>> get entries => _map.entries;
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K key, V value) convert) => _map.map(convert);
  Iterable<K> get keys => _map.keys;
  Iterable<V> get values => _map.values;
  int get length => _map.length;
  bool get isEmpty => _map.isEmpty;
  bool get isNotEmpty => !isEmpty;
  void forEach(void Function(K key, V value) action) => _map.forEach(action);

  static final Error _unsuported = UnsupportedError("Cant modify a read only map");
  void operator []=(K key, V value) => throw _unsuported;
  void addAll(Map<K, V> other) => throw _unsuported;
  void addEntries(Iterable<MapEntry<K, V>> newEntries) => throw _unsuported;
  Map<RK, RV> cast<RK, RV>() => throw _unsuported;
  void clear() => throw _unsuported;
  V putIfAbsent(K key, V Function() ifAbsent) => throw _unsuported;
  V? remove(Object? key) => throw _unsuported;
  void removeWhere(bool Function(K key, V value) test) => throw _unsuported;
  V update(K key, V Function(V value) update, {V Function()? ifAbsent}) => throw _unsuported;
  void updateAll(V Function(K key, V value) update) => throw _unsuported;
}

extension ReadOnlyMapX<K, V> on Map<K, V> {
  ReadOnlyMap<K, V> get readOnly => ReadOnlyMap(this);
}
