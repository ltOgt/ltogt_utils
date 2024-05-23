({T result, Duration duration}) timed<T>(T Function() f) {
  final t0 = DateTime.now();
  final r = f();
  final t1 = DateTime.now();
  return (result: r, duration: t1.difference(t0));
}

Future<({T result, Duration duration})> timedAsync<T>(Future<T> Function() f) async {
  final t0 = DateTime.now();
  final r = await f();
  final t1 = DateTime.now();
  return (result: r, duration: t1.difference(t0));
}

class TimeMeasure {
  final DateTime t0 = DateTime.now();
  Duration ellasped() => DateTime.now().difference(t0);
}
