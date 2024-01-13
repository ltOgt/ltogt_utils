// ignore_for_file: public_member_api_docs, sort_constructors_first
sealed class SealedUnion<L, R> {
  T resolve<T>({
    required T Function(L l) onLeft,
    required T Function(R r) onRight,
  }) =>
      switch (this) {
        final SealedUnionLeft left => onLeft(left.value),
        final SealedUnionRight right => onRight(right.value),
      };

  const factory SealedUnion.left(L l) = SealedUnionLeft<L, R>;
  const factory SealedUnion.right(R r) = SealedUnionRight<L, R>;

  const SealedUnion();
}

class SealedUnionLeft<L, R> extends SealedUnion<L, R> {
  final L value;

  const SealedUnionLeft(this.value);

  @override
  bool operator ==(covariant SealedUnionLeft<L, R> other) {
    if (identical(this, other)) return true;

    return other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

class SealedUnionRight<L, R> extends SealedUnion<L, R> {
  final R value;

  const SealedUnionRight(this.value);

  @override
  bool operator ==(covariant SealedUnionRight<L, R> other) {
    if (identical(this, other)) return true;

    return other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
