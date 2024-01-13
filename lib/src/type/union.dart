import 'package:ltogt_utils/src/null/null_helpers.dart';

@Deprecated("Use SealedUnion<L,R> instead")
class Union2<A, B> {
  A? a;
  B? b;

  Union2({
    this.a,
    this.b,
  }) : assert(oneNotNull([a, b]));

  @override
  String toString() => "Union(" + (a != null ? 'a: $a' : 'b: $b') + ")";
}

@Deprecated("Use SealedUnion<L,R> instead")
class Union3<A, B, C> {
  A? a;
  B? b;
  B? c;

  Union3({
    this.a,
    this.b,
    this.c,
  }) : assert(oneNotNull([a, b, c]));
}
