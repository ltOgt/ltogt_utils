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
  static String nextChar(String s, [int i = 1]) => charFromInt(charAsInt(s) + i);
  static String charFromInt(int i, [String? base]) => String.fromCharCode(i + (orNull(() => charAsInt(base!)) ?? 0));
  static int charAsInt(String s) => s.codeUnits.first;
  static String charAt(String s, int index) => String.fromCharCode(s.codeUnits[index]);

  /// Returns a list of two strings
  /// - first from 0 to [index] (excl)
  /// - second from [index] to the end
  static List<String> splitAt(String s, int index) => [s.substring(0, index), s.substring(index)];

  /// Gets the character at [i] and searches left and right for the next [delimiter].
  /// Returns the word in between those [delimiter]s.
  ///
  /// § ("Hello my Friend", 6) => "my"
  /// § ("Hello my Friend", 0) => "Hello"
  /// § ("Hello my Friend", 5) => null
  static String? wordAtIndex(String s, int i, [String delimiter = " "]) => wordAtIndexBounds(s, i)?.forSubstring(s);

  /// Gets the character at [i] and searches left and right for the next [delimiter].
  /// Returns the bounds of the word in between those [delimiter]s.
  ///
  /// § ("Hello my Friend", 6) => (6,8)
  /// § ("Hello my Friend", 0) => (0,5)
  /// § ("Hello my Friend", 5) => null
  static StringOffset? wordAtIndexBounds(String s, int i, [String delimiter = " "]) {
    assert(delimiter.length == 1, "Only works for single char delimiters");
    if (i >= s.length || i < 0) return null;
    if (charAt(s, i) == delimiter) return null;

    int? start, end;

    final split = splitAt(s, i);
    final first = split.first;
    final last = split.last;

    if (first.isNotEmpty) {
      for (int back = first.length - 1; back >= 0; back--) {
        final char = String.fromCharCode(first.codeUnits[back]);
        if (char == delimiter) {
          start = back + 1;
          break;
        }
      }
    }
    if (last.isNotEmpty) {
      for (int forward = 0; forward < last.codeUnits.length; forward++) {
        final char = String.fromCharCode(last.codeUnits[forward]);
        if (char == delimiter) {
          end = i + forward;
          break;
        }
      }
    }

    return StringOffset(start ?? 0, end ?? s.length);
  }
}
