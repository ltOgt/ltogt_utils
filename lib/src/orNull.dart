/// Runs a method, returns null on any exception
T? orNull<T>(T Function() call) {
  try {
    return call();
  } catch (_) {
    return null;
  }
}
