import 'package:ltogt_utils/ltogt_utils.dart';

class StringHelper {
  StringHelper._();
  static bool isFilled(String? s) => s != null && s.trim().isNotEmpty;

  /// Tries to find the first match of [pattern] in [target].
  /// Returns only first if found, otherwise null.
  static Match? matchSubstring(String target, String pattern) {
    // computes lazily, so should always only be first match
    // worst-case checks substring for each char as start
    final matches = pattern.allMatches(target);
    if (matches.isNotEmpty) {
      return matches.first;
    }
    return null;
  }

  /// Splits String into 3 segments based on StringOffset
  /// - 0-matchStart
  ///   - might be empty
  /// - matchStart-matchEnd
  ///   - might be whole of [s]
  /// - matchEnd-stringEnd
  ///   - might be empty
  static List<String> splitStringBasedOnMatch(String s, StringOffset match) {
    assert(match.startIncl <= s.length && match.endExcl <= s.length, "s=<$s>, match=<$match>");

    bool isMatchFromStart = match.startIncl == 0;
    bool isMatchToEnd = match.endExcl == s.length;

    return [
      isMatchFromStart ? "" : s.substring(0, match.startIncl),
      s.substring(match.startIncl, match.endExcl),
      isMatchToEnd ? "" : s.substring(match.endExcl, s.length),
    ];
  }

  /// Ignores all but the first char of the string.
  /// Breaks on empty string.
  static nextChar(String s, [int i = 1]) => charFromInt(charAsInt(s) + i);
  static charFromInt(int i, [String? base]) => String.fromCharCode(i + (orNull(() => charAsInt(base!)) ?? 0));
  static charAsInt(String s) => s.codeUnits.first;
}
