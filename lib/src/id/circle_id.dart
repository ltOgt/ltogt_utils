/// Very simple ID generator that uses the timestamp plus a circular number to circumvent identical ids on fast sucessive calls.
class CircleIdGen {
  int _circle = 0;
  static const _circleMax = 10000;

  CircleIdGen();

  CircleId get next => CircleId(DateTime.now().toIso8601String() + (_circle++ % _circleMax).toString());
}

class CircleId {
  final String value;

  CircleId(this.value);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CircleId && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'CircleId($value)';
}
