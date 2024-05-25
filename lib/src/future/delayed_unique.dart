/// This is just for suggestion discovery since i often search for debounce helper instead
@Deprecated("Use DelayedUnique")
typedef DebounceHelper_ = DelayedUnique;

/// A static class that helps with delayed calls that might get triggered often
/// but should only run once.
///
/// - § listen to a scroll controller and react to the last event
/// - § do something after hovering for X seconds, or abort if exited before X
abstract class DelayedUnique {
  static Map<String, DateTime> _keyToLatestCall = {};

  /// Run a [call] after [wait] iff
  /// - no other [call] with the same [key] was registered during [wait]
  /// - the call was not [abort]ed during [wait]
  static void register({
    required String key,
    required Duration wait,
    required Function call,
  }) {
    DateTime thisCall = DateTime.now();
    _keyToLatestCall[key] = thisCall;
    Future.delayed(wait, () {
      final lastCall = _keyToLatestCall[key];
      if (lastCall == thisCall) {
        call();
        _keyToLatestCall.remove(key);
      }
    });
  }

  /// Check if a [call] was registered with [key] in [register],
  /// which has not yet been executed ([wait] not over).
  static bool isRegistered(String key) {
    return _keyToLatestCall.containsKey(key);
  }

  /// Abort a [call] that was registered with [key] in [register],
  /// which has not yet been executed ([wait] not over).
  static bool abort(String key) {
    return _keyToLatestCall.remove(key) != null;
  }
}
