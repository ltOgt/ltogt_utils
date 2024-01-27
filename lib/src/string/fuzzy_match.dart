// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:characters/characters.dart';
import 'package:collection/collection.dart';

class FuzzyMatch {
  final bool startsWithMatch;
  final List<String> segments;

  bool get hasMatch => startsWithMatch || segments.length > 2;

  FuzzyMatch._(this.startsWithMatch, this.segments);
  FuzzyMatch({required this.startsWithMatch, required this.segments});

  @override
  bool operator ==(covariant FuzzyMatch other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.startsWithMatch == startsWithMatch && listEquals(other.segments, segments);
  }

  @override
  int get hashCode => startsWithMatch.hashCode ^ DeepCollectionEquality().hash(segments);

  @override
  String toString() => 'FuzzyMatch(startsWithMatch: $startsWithMatch, segments: $segments)';
}

abstract class FuzzyMatcher {
  static FuzzyMatch matchQuery(String query, String target, {bool caseSensitive = true}) {
    if (query.isEmpty) return FuzzyMatch._(false, [target]);
    if (target.isEmpty) return FuzzyMatch._(false, [target]);

    final queryChars = query.characters.toList();
    final targetChars = target.characters.toList();
    final int targetLength = targetChars.length;
    final int queryLength = queryChars.length;

    final bool isFirstMatch = caseSensitive
        ? queryChars.first == targetChars.first
        : queryChars.first.toLowerCase() == targetChars.first.toLowerCase();

    List<String> aggregate = [];
    StringBuffer buffer = StringBuffer();

    int queryIndex = 0;
    bool isMatchMode = isFirstMatch;

    for (int targetIndex = 0; targetIndex < targetLength; ++targetIndex) {
      final currentQueryChar = queryChars[queryIndex];
      final currentTargetChar = targetChars[targetIndex];

      bool isCurrentMatch = caseSensitive
          ? currentQueryChar == currentTargetChar
          : currentQueryChar.toLowerCase() == currentTargetChar.toLowerCase();

      if (isCurrentMatch) {
        queryIndex += 1;
        // We found a match
        if (isMatchMode) {
          // Stay in match mode and add to buffer
          buffer.write(currentTargetChar);
        } else {
          // switch to match mode
          isMatchMode = true;
          aggregate.add(buffer.toString());
          buffer.clear();
          buffer.write(currentTargetChar);
        }

        if (queryIndex >= queryLength) {
          // End of query
          aggregate.add(buffer.toString());
          // Add rest of target as non match
          targetIndex += 1;
          if (targetIndex < targetLength) {
            aggregate.add(targetChars.sublist(targetIndex).join());
          }
          return FuzzyMatch._(isFirstMatch, aggregate);
        }
      } else {
        // We did not find a match
        if (isMatchMode) {
          // finish the match
          isMatchMode = false;
          aggregate.add(buffer.toString());
          buffer.clear();
        }
        buffer.write(currentTargetChar);
      }
    }

    if (queryIndex < queryLength) return FuzzyMatch._(false, [target]);

    aggregate.add(buffer.toString());

    return FuzzyMatch._(isFirstMatch, aggregate);
  }
}
