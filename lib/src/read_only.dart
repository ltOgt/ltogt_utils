import 'dart:collection';

extension ReadOnlyMapX<K, V> on Map<K, V> {
  UnmodifiableMapView<K, V> get readOnly => UnmodifiableMapView(this);
}

extension ReadOnlySetX<E> on Set<E> {
  UnmodifiableSetView<E> get readOnly => UnmodifiableSetView(this);
}

extension ReadOnlyListX<E> on List<E> {
  UnmodifiableListView<E> get readOnly => UnmodifiableListView(this);
}
