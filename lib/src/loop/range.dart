class Range extends Iterable {
  @override
  final Iterator iterator;

  Range({
    required int max,
    int min = 0,
    bool increment = true,
  }) : iterator = _RangeIterator(
          max: max,
          min: min,
          increment: increment,
        );
}

class _RangeIterator implements Iterator {
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
        assert(max > min);

  // TODO consider adding length constructor

}
