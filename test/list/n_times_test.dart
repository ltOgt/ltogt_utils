// Import the test package and Counter class
import 'package:ltogt_utils/src/list/n_times.dart';
import 'package:test/test.dart';

class _Foo {
  @override
  bool operator ==(Object other) => other is _Foo;
  @override
  int get hashCode => 0;
}

void main() {
  test('n times', () async {
    expect(times(3, 3), equals([3, 3, 3]));
    expect(times(4, "Hi"), equals(["Hi", "Hi", "Hi", "Hi"]));
    expect(times(1, _Foo), equals([_Foo]));
    expect(times(2, _Foo()), equals([_Foo(), _Foo()]));
  });
}
