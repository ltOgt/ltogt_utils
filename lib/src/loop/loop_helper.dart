class LoopHelper {
  /// For-Each loop with index
  ///
  /// Beware: can not use continue or return inside f like you would in regular loops
  static forEach<T>(List<T> l, Function(T element, int index) f) {
    for (int i = 0; i < l.length; i++) {
      f(l[i], i);
    }
  }
}
