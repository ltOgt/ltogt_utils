/// Stack using [List] to store the entries;
///
/// "default Dart Queue itself uses a list"
/// See https://stackoverflow.com/a/64060945
class StackList<E> {
  final _entries = <E>[];

  void put(E e) => _entries.add(e);
  E pop(E e) => _entries.removeLast();

  int get depth => _entries.length - 1;
  bool get isEmpty => _entries.isEmpty;
  bool get isNotEmpty => _entries.isNotEmpty;
}
