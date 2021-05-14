extension ListExtension<E> on Iterable<E> {
  /// Returns a new eagerly computed [List] with elements of type [T] that are created by
  /// calling `f` on each element of this `List` with elements of type [E] in order of increasing index.
  ///
  /// `f` exposes the index and the element at that index.
  ///
  /// ___________
  /// For example:
  ///
  /// ```
  /// ["a", "b", "c"].forEachIndexed((int index, String element) => {index: element});
  /// ```
  ///
  /// Returns `[{0: a}, {1: b}, {2: c}]`
  ///
  List<T> forEachIndexed<T>(T f(int index, E e)) {
    List<T> r = [];
    for (int i = 0; i < this.length; i++) {
      r.add(
        f(i, this.elementAt(i)),
      );
    }
    return r;
  }

  /// But the [insertable] inbetween the elements of [original].
  ///
  /// [beforeFirst] => put [insertable] at the beggining as well
  /// [afterLast] => put [insertable] at the end as well
  List<E> intertwineWith(E insertable, {bool beforeFirst = false, bool afterLast = false}) {
    List<E> r = [];
    if (beforeFirst) {
      r.add(insertable);
    }
    for (E e in this) {
      r.add(e);
      r.add(insertable);
    }
    if (this.length == 0) {
      if (afterLast) {
        r.add(insertable);
      }
    } else {
      if (!afterLast) {
        r.removeLast();
      }
    }

    return r;
  }
}
