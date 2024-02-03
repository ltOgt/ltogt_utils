class Range extends Iterable<int> {
  @override
  _RangeIterator get iterator => _gen();

  final _RangeIterator Function() _gen;

  /// [max] and [min] are inclusive
  Range(
    int max, {
    int min = 0,
    bool increment = true,
  }) : _gen = (() => _RangeIterator(
              max: max + (increment ? 0 : 1),
              min: min + (increment ? -1 : 0),
              increment: increment,
            ));
}

class _RangeIterator implements Iterator<int> {
  @override
  int current;
  @override
  bool moveNext() => _isIncrement ? _increment() : _decrement();

  bool _increment() {
    if (current < _limit) {
      current += 1;
      return true;
    }
    return false;
  }

  bool _decrement() {
    if (current > _limit) {
      current -= 1;
      return true;
    }
    return false;
  }

  // increment to limit
  // else decrement to limit
  final bool _isIncrement;
  final int _limit;

  _RangeIterator({
    required int max,
    int min = 0,
    bool increment = true,
  })  : current = increment ? min : max,
        _limit = increment ? max : min,
        _isIncrement = increment,
        assert(max >= min);

  // TODO consider adding length constructor
}
