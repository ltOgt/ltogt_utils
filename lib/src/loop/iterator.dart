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

/// Iterable over [list] which will return [DoubleIndexedItem]s
/// containing the original [DoubleIndexedItem.value] of [list]
/// along with the [DoubleIndexedItem.index] and [DoubleIndexedItem.reverseIndex].
///
/// ```dart
/// for (final indexed in DoubleIndexed(["a", "b", "c"])) {
///   print("${indexed.index}-${indexed.reverseIndex} : ${indexed.item}");
///   // => "0-2 : a" // isFirst == true
///   // => "1-1 : b" // isMiddle == true
///   // => "2-0 : c" // isLast == true
/// }
/// ```
class DoubleIndexed<E> extends Iterable<DoubleIndexedItem<E>> {
  @override
  _DoubleIndexedAccessIterator<E> get iterator => new _DoubleIndexedAccessIterator(list);

  final List<E> list;

  DoubleIndexed(this.list);
}

class _DoubleIndexedAccessIterator<E> extends Iterator<DoubleIndexedItem<E>> {
  final List<E> list;

  int index = -1;
  late int indexReverse = list.length;

  /// `moveNext` must be called before this can be accessed
  @override
  DoubleIndexedItem<E> get current => DoubleIndexedItem(index, indexReverse, list[index]);

  @override
  bool moveNext() {
    index += 1;
    indexReverse -= 1;
    return indexReverse > -1;
  }

  _DoubleIndexedAccessIterator(this.list);
}

class DoubleIndexedItem<E> {
  final int index;
  final int reverseIndex;
  final E value;

  bool get isFirst => index == 0;
  bool get isLast => reverseIndex == 0;

  /// is this item exactly in the middle of its siblings
  /// only possible in odd numbered lists
  bool get isMiddleExact => index == reverseIndex;

  /// is this item the last of the first half of the children
  /// i.e. one of the two middle items in even numbered lists
  /// only possible in even numbered lists
  bool get isMiddlePre => index + 1 == reverseIndex;

  /// is this item the first of the second half of the children
  /// i.e. one of the two middle items in even numbered lists
  /// only possible in even numbered lists
  bool get isMiddlePost => index - 1 == reverseIndex;

  /// Either [isMiddleExact] (diff 0) or [isMiddlePre]/[isMiddlePost] (diff 1)
  bool get isMiddle => (index - reverseIndex).abs() < 2;

  DoubleIndexedItem(this.index, this.reverseIndex, this.value);
}
