import 'package:ltogt_utils/src/assert/xor_params.dart';

class Union2<A, B> {
  A? a;
  B? b;

  Union2({
    this.a,
    this.b,
  }) : assert(xorParams([a, b]));

  @override
  String toString() => "Union(" + (a != null ? 'a: $a' : 'b: $b') + ")";
}

class Union3<A, B, C> {
  A? a;
  B? b;
  B? c;

  Union3({
    this.a,
    this.b,
    this.c,
  }) : assert(xorParams([a, b, c]));
}
