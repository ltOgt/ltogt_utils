/// Do something with [value] if it is not null, otherwise simply return null
/// Replaces the annoying `value == null ? null : doStuff(value)`
R? ifNotNull<T, R>(T? value, R Function(T value) givenNotNull) {
  return value == null ? null : givenNotNull(value);
}
