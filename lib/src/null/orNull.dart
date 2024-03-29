/// Executes a [call] and returns `null` on any exception.
///
/// If [test] is specified, exceptions are rethrown if [test] returns `false`.
T? orNull<T>(T Function() call, {bool Function(Object err)? test}) {
  try {
    return call();
  } catch (err) {
    if (!(test?.call(err) ?? true)) {
      rethrow;
    }
    return null;
  }
}

Future<T?> orNullAsync<T>(Future<T> Function() call, {bool Function(Object err)? test}) async {
  try {
    return await call();
  } catch (err) {
    if (!(test?.call(err) ?? true)) {
      rethrow;
    }
    return null;
  }
}
