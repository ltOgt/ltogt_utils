/// Iterable over [iterator] which will return [IndexedItem]s
/// containing the original [IndexedItem.value] of [iterator]
/// along with the [IndexedItem.index] of regular iteration order.
///
/// ```dart
/// for (final indexed in Indexed(["a", "b", "c"])) {
///   print("${indexed.index} : ${indexed.item}");
///   // => "0 : a"
///   // => "1 : b"
///   // => "2 : c"
/// }
/// ```
///
/// Which is mostly the same as the following, only semantically clearer:
/// ```dart
/// for (final entry in ["a", "b", "c"].asMap().entries) {
///   print("${entry.key} : ${entry.value}");
///   // => "0 : a"
///   // => "1 : b"
///   // => "2 : c"
/// }
/// ```
class Indexed<E> extends Iterable<IndexedItem<E>> {
  @override
  _IndexedAccessIterator<E> get iterator => new _IndexedAccessIterator(iterable.iterator);

  final Iterable<E> iterable;

  Indexed(this.iterable);
}

class _IndexedAccessIterator<E> extends Iterator<IndexedItem<E>> {
  final Iterator<E> iterator;

  int currentIndex = -1;

  /// `moveNext` must be called before this can be accessed
  @override
  IndexedItem<E> get current => IndexedItem(currentIndex, iterator.current);

  @override
  bool moveNext() {
    currentIndex += 1;
    return iterator.moveNext();
  }

  _IndexedAccessIterator(this.iterator);
}

class IndexedItem<E> {
  final int index;
  final E value;

  IndexedItem(this.index, this.value);
}

/// Iterable over [List] which will be iterated over in reverse without reversing the actual [List].
/// Does not work for abitrary [Iterable], since those have no notion of length.
///
/// ```dart
/// for (final reversed in Reversed(["x", "a", "b", "c", "x"], skipEnd:1, skipStart:1)) {
///   print(reversed);
///   // => "c"
///   // => "b"
///   // => "a"
/// }
/// ```
///
/// Which is mostly the same as the following, only semantically clearer:
/// ```dart
/// final list = ["x", "a", "b", "c", "x"];
/// final skipEnd = 1;
/// final skipStart = 1;
/// for (int i = list.length - 1 - skipStart; i > skipEnd; i--) {
///   print(list[i]);
///   // => "c"
///   // => "b"
///   // => "a"
/// }
/// ```
class Reversed<E> extends Iterable<E> {
  @override
  _ReversedIterator<E> get iterator => new _ReversedIterator(this);

  final List<E> list;

  /// - [skipEnd] will skip that amount from the end of the REVERSED list
  ///   - so: [1,2,3] skipEnd=1  => [3,2]
  final int skipEnd;

  /// - [skipStart] will skip that amount from the start of the REVERSED list
  ///   - so: [1,2,3] skipStart=1  => [2,1]
  final int skipStart;

  Reversed(this.list, {this.skipEnd = 0, this.skipStart = 0});
}

class _ReversedIterator<E> extends Iterator<E> {
  final Reversed<E> _iterable;

  late int _currentIndex = _iterable.list.length - _iterable.skipStart;

  /// `moveNext` must be called before this can be accessed
  @override
  E get current => _iterable.list[_currentIndex];

  @override
  bool moveNext() {
    return _currentIndex-- > _iterable.skipEnd;
  }

  _ReversedIterator(this._iterable);
}
