import 'dart:async';

/// Sometimes a nested future throws an exception that is not caught anywhere.
/// The usual `onError` and `catchError` callbacks might not help.
///
/// Using [runZoned] and [ZoneSpecification]s [handleUncaughtError]
/// one can still catch the error before it bubbles to the top.
Future<R> asyncBarrier<R>({
  required Future<R> Function() executor,
  required void Function(dynamic error) onUncaughtError,
}) async {
  return await runZoned(
    () async {
      return await executor();
    },
    zoneSpecification: ZoneSpecification(
      handleUncaughtError: (_, __, ___, error, stacktrace) {
        onUncaughtError(error);
      },
    ),
  );
}
