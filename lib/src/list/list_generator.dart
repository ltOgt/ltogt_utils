import 'package:ltogt_utils/src/list/list_extension.dart';

class ListGenerator {
  ListGenerator._();

  /// Like [List.generate(length, generator)] but with the actual list items instead of index.
  ///
  /// [ListGenerator.forEach] is like `for(var item in items)` where
  /// [List.generate] is like `for(int i=0; i < items.length; i++)`
  ///
  static List<R> forEach<T, R>({
    required List<T> list,
    required R Function(T item, int index) builder,
  }) =>
      List.generate(
        list.length,
        (index) => builder(list[index], index),
      );

  /// Like [List.generate(length, generator)] but with start and end index instead.
  ///
  /// [from] inclusive
  ///
  /// [to] exclusive
  ///
  /// [generator] generates List elements from the index starting at [from] and ending at [to]-1
  ///
  static List<R> forRange<R>({
    int from = 0,
    required int to,
    required R Function(int index) generator, // TODO rename to builder instead
  }) {
    return List.generate(
      to - from,
      (index) => generator(index + from),
    );
  }

  /// Like [ListGenerator.forEach] but with [seperator] added in between elements.
  ///
  /// Set [leadingSeperator] to add [seperator] before the first item.
  /// Set [trailingSeperator] to add [seperator] after the last item.
  ///
  // TODO intertwine might be a better name
  static List<R> seperated<T, R>({
    required List<T> list,
    required R Function(T item, int index) builder,
    bool leadingSeperator = false,
    bool trailingSeperator = false,
    required R seperator,
  }) =>
      ListExtension(
        List.generate(
          list.length,
          (index) => builder(list[index], index),
        ),
      ).intertwineWith(
        seperator,
        beforeFirst: leadingSeperator,
        afterLast: trailingSeperator,
      );

  static List<R> fromMap<K, V, R>({
    required Map<K, V?> map,
    required R Function(K key, V? value) builder,
  }) =>
      List.generate(
        map.keys.length,
        (index) {
          final key = map.keys.elementAt(index);
          return builder(key, map[key]);
        },
      );
}
