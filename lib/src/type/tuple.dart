@Deprecated("Use records language feature instead")
class Tuple<A, B> {
  final A a;
  final B b;

  const Tuple({
    required this.a,
    required this.b,
  });

  @override
  String toString() => "Tuple(" + ('a: $a, b: $b') + ")";
}

@Deprecated("Use records language feature instead")
class Triple<A, B, C> {
  final A a;
  final B b;
  final B c;

  const Triple({
    required this.a,
    required this.b,
    required this.c,
  });

  @override
  String toString() => "Triple(" + ('a: $a, b: $b, c: $c') + ")";
}
