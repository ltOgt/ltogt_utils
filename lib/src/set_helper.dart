abstract class SetHelper {
  /// (.{x).} - Elements that are in [left] AND in [right]
  static Set<T> innerJoin<T>(Set<T> left, Set<T> right) => {
        for (final l in left) //
          if (right.contains(l)) //
            l,
      };

  /// (x{x).} - Elements that are in [left] OR ([left] AND in [right])
  static Set<T> leftJoin<T>(Set<T> left, Set<T> right) => {...left};

  /// (x{.).} - Elements that are in [left] AND NOT in [right]
  static Set<T> leftOuterJoin<T>(Set<T> left, Set<T> right) => {
        for (final l in left) //
          if (false == right.contains(l)) //
            l,
      };

  /// (.{x)x} - Elements that are in [right] OR ([right] AND in [left])
  static Set<T> rightJoin<T>(Set<T> left, Set<T> right) => SetHelper.leftJoin(right, left);

  /// (.{.)x} - Elements that are in [right] AND NOT in [left]
  static Set<T> rightOuterJoin<T>(Set<T> left, Set<T> right) => SetHelper.leftOuterJoin(right, left);

  /// (x{.)x} - Elements that are in [left] ONLY OR ONLY in [right]
  static Set<T> outerJoin<T>(Set<T> left, Set<T> right) => {
        ...SetHelper.leftOuterJoin(left, right),
        ...SetHelper.rightOuterJoin(left, right),
      };

  /// (x{x)x} - Elements that are in [left] OR in [right] (all)
  static Set<T> fullJoin<T>(Set<T> left, Set<T> right) => {
        ...left,
        ...right,
      };
}
