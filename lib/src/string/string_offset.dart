class StringOffset {
  final int startIncl;
  final int endExcl;

  const StringOffset(this.startIncl, this.endExcl);

  static StringOffset? fromRegexMatchOrNull(RegExpMatch? match) =>
      match == null ? null : StringOffset(match.start, match.end);

  static StringOffset? fromSubstringMatchOrNull(Match? match) =>
      match == null ? null : StringOffset(match.start, match.end);

  @override
  String toString() => 'StringOffset(startIncl: $startIncl, endExcl: $endExcl)';
}
