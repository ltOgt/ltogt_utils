import 'dart:math';

class RandomUtils {
  final Random random = Random();

  Map<K, dynamic> randomMap<K>({
    required int maxDepth,
    required int maxBredth,
    required K rootKey,
    required K Function(K parent, int posInParent, int parentChildCount, int depth) getKey,
  }) =>
      _randomMap(
        depth: 0,
        maxDepth: maxDepth,
        maxBredth: maxBredth,
        parentKey: rootKey,
        posInParent: 0,
        parentChildCount: 1,
        getKey: getKey,
      );

  Map<K, dynamic> _randomMap<K>({
    required int depth,
    required int maxDepth,
    required int maxBredth,
    required K parentKey,
    required int posInParent,
    required int parentChildCount,
    required K Function(K parent, int posInParent, int parentChildCount, int depth) getKey,
  }) =>
      {
        for (int i = 0, len = random.nextInt(maxBredth - 1) + 1; i < len; i++) //
          getKey(parentKey, i, len, depth): maxDepth == depth
              ? {}
              : _randomMap(
                  depth: depth + 1,
                  maxDepth: maxDepth,
                  maxBredth: maxBredth,
                  parentKey: getKey(parentKey, i, len, depth),
                  posInParent: i,
                  parentChildCount: len,
                  getKey: getKey,
                ),
      };
}
