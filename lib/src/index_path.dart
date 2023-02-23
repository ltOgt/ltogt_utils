/// A list of indexes that can be used to define a path in a nested structure.
///
/// E.g. the following two mean the same:
///
/// x[0][1][4][1] ^= [0,1,4,1]
typedef IndexPath = List<int>;

abstract class IndexPathHelper {
  /// Get the element [T] at [indexPath] via iterative application of [getNext] with the indexes in [indexPath]
  static T extract<T>({required T Function(T? current, int i) getNext, required IndexPath indexPath}) {
    if (indexPath.isEmpty) throw Exception("Empty Index Path not allowed");

    T current = getNext(null, indexPath.first);
    for (int i = 1; i < indexPath.length; i++) {
      current = getNext(current, indexPath[i]);
    }
    return current;
  }
}
