import 'package:ltogt_utils/ltogt_utils.dart';

/// Stack using [List] to store the entries;
///
/// "default Dart Queue itself uses a list"
/// See https://stackoverflow.com/a/64060945
class StackList<E> {
  final _entries = <E>[];

  void put(E e) => _entries.add(e);
  E pop() => _entries.removeLast();

  int get depth => _entries.length - 1;
  bool get isEmpty => _entries.isEmpty;
  bool get isNotEmpty => _entries.isNotEmpty;

  E get last => _entries.last;
  E? depthOrNull(int depth) => orNull(
        () => depth < 0 //
            ? _entries[_entries.length + depth] // -1 etc
            : _entries[depth],
      );

  @override
  String toString() => "StackList<$E>($_entries)";
}
