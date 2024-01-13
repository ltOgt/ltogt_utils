sealed class SealedUnion<L, R> {
  T resolve<T>({
    required T Function(L l) onLeft,
    required T Function(R r) onRight,
  }) =>
      switch (this) {
        final SealedUnionLeft left => onLeft(left.value),
        final SealedUnionRight right => onRight(right.value),
      };

  factory SealedUnion.left(L l) => SealedUnionLeft(value: l);
  factory SealedUnion.right(R r) => SealedUnionRight(value: r);

  SealedUnion();
}

class SealedUnionLeft<L, R> extends SealedUnion<L, R> {
  final L value;

  SealedUnionLeft({required this.value});
}

class SealedUnionRight<L, R> extends SealedUnion<L, R> {
  final R value;

  SealedUnionRight({required this.value});
}
