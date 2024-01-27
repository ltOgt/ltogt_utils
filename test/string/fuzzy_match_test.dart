import 'package:ltogt_utils/src/string/fuzzy_match.dart';
import 'package:test/test.dart';

void main() {
  test('FuzzyMatcher.matchQuery', () {
    expect(
      FuzzyMatcher.matchQuery("aefj", "abc def hijklm"),
      FuzzyMatch(startsWithMatch: true, segments: ["a", "bc d", "ef", " hi", "j", "klm"]),
    );

    expect(
      FuzzyMatcher.matchQuery("xyz", "abc def hijklm"),
      FuzzyMatch(startsWithMatch: false, segments: ["abc def hijklm"]),
    );

    expect(
      FuzzyMatcher.matchQuery("abcdefhij", "abc def hi"),
      FuzzyMatch(startsWithMatch: false, segments: ["abc def hi"]),
    );
  });
}
