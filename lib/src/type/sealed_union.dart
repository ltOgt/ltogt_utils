sealed class SealedUnion<L, R> {
  void resolve({
    required void Function(L l) onLeft,
    required void Function(L l) onRight,
  }) =>
      switch (this) {
        final SealedUnionLeft left => left.value,
        final SealedUnionRight right => right.value,
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
