/// Tries to execute [tryThis] and return its result.
/// If [tryThis] throws, [elseThis] is returned.
///
/// Unless [useElse] is specified and returns `false`,
/// in which case the exception is rethrown
T tryOr<T>(
  T Function() tryThis,
  T elseThis, {
  bool Function(Object e)? useElse,
}) {
  try {
    return tryThis();
  } catch (e) {
    if (useElse == null || useElse(e)) {
      return elseThis;
    }
    rethrow;
  }
}
