extension PUT_ASYNC_X<K, V> on Map<K, V> {
  Future<V> putIfAbsentAsync(K key, Future<V> ifAbsent()) async {
    final valueIfAny = this[key];
    if (valueIfAny != null) return valueIfAny;
    final value = await ifAbsent();
    this[key] = value;
    return value;
  }
}
