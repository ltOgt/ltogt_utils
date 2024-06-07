import 'dart:math';

import 'package:ltogt_utils/src/mutator.dart';

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

  E? firstWhereOrNull(bool Function(E e) test) {
    try {
      return this.firstWhere((e) => test(e));
    } on StateError catch (_) {
      return null;
    }
  }

  R collect<R>(R init, R Function(R acc, E ele) collector) {
    R acc = init;
    for (final e in this) {
      acc = collector(acc, e);
    }
    return acc;
  }

  E pyIndex(int i) => i > 0 //
      ? this.elementAt(i)
      : this.elementAt(this.length + i);
}

extension ListExtensionList<E> on List<E> {
  /// ```dart
  /// final colors = <String>['red', 'green', 'blue', 'orange', 'pink'];
  /// print(colors.sublist(1, 3)); // [green, blue]
  /// ```
  List<E> sublistSafe(int start, [int? end]) {
    return sublist(
      max(0, start),
      end == null ? null : min(length, end),
    );
  }

  List<E> copyWithChangedAtIndex(int index, Mutator<E>? change) {
    return [
      for (final (i, e) in this.indexed) //
        if (i != index) //
          e
        else if (change != null)
          change(e),
    ];
  }

  List<E> copyWithChanged(bool Function(int index, E element) shouldChange, Mutator<E>? change) {
    return [
      for (final (i, e) in this.indexed) //
        if (!shouldChange(i, e)) //
          e
        else if (change != null)
          change(e),
    ];
  }
}
