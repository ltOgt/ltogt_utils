// TODO needs testing lol

import '../use.dart';
import '../read_only.dart';

/// Manages two maps in conjunction.
///
/// - [_oneToMany] maps :one: instance of [O] to a [Set] of :many: [M].
/// - [_back] maps a single [M] back to the one [O].
class OneToMany<O, M> {
  final Map<O, Set<M>> _oneToMany = {};
  final Map<M, O> _back = {};

  Set<M>? getAllForOne(O one) => _oneToMany[one]?.use((set) => set.readOnly);
  O? getOneForOneOfMany(M oneOfMany) => _back[oneOfMany];

  void add(O one, M oneOfMany) {
    _oneToMany.putIfAbsent(one, () => {}).add(oneOfMany);
    _back[oneOfMany] = one;
  }

  void addAll(O one, Set<M> many) {
    _oneToMany.putIfAbsent(one, () => {}).addAll(many);
    for (final m in many) {
      _back[m] = one;
    }
  }

  void remove(O one) {
    if (!_oneToMany.containsKey(one)) return;

    for (final m in _oneToMany[one]!) {
      _back.remove(m);
    }
    _oneToMany.remove(one);
  }

  void removeOneOfMany(M oneOfMany) {
    if (!_back.containsKey(oneOfMany)) return;

    final one = _back.remove(oneOfMany);
    assert(_oneToMany.keys.contains(one));
    _oneToMany[one]!.remove(oneOfMany);
  }

  Iterable<O> get keys => _oneToMany.keys;
}
