import 'dart:math';

class RandomUtils {
  final Random random = Random();

  T randomFrom<T>(List<T> l) => l[random.nextInt(l.length - 1)];

  Map<K, dynamic> randomTreeMap<K>({
    required int maxDepth,
    required int maxBreadth,
    int minBreadth = 1,
    required K rootKey,
    required K Function(K parent, int posInParent, int parentChildCount, int depth) getKey,
  }) {
    assert(minBreadth <= maxBreadth);
    return _randomTreeMap(
      depth: 0,
      maxDepth: maxDepth,
      maxBreadth: maxBreadth,
      minBreadth: minBreadth,
      parentKey: rootKey,
      posInParent: 0,
      parentChildCount: 1,
      getKey: getKey,
    );
  }

  Map<K, dynamic> _randomTreeMap<K>({
    required int depth,
    required int maxDepth,
    required int maxBreadth,
    required int minBreadth,
    required K parentKey,
    required int posInParent,
    required int parentChildCount,
    required K Function(K parent, int posInParent, int parentChildCount, int depth) getKey,
  }) =>
      {
        for (int i = 0, len = random.nextInt(maxBreadth - minBreadth) + minBreadth; i < len; i++) //
          getKey(parentKey, i, len, depth): maxDepth == depth
              ? {}
              : _randomTreeMap(
                  depth: depth + 1,
                  maxDepth: maxDepth,
                  maxBreadth: maxBreadth,
                  minBreadth: minBreadth,
                  parentKey: getKey(parentKey, i, len, depth),
                  posInParent: i,
                  parentChildCount: len,
                  getKey: getKey,
                ),
      };
}
