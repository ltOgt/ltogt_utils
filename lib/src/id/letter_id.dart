import 'package:ltogt_utils/ltogt_utils.dart';

class LetterIdGen {
  int _index = 0;
  int _ceil = 26;
  String _value = "A";

  String _valueForIndex(int index) {
    return branchingIndex(index, _ceil).map((e) => StringHelper.charFromInt(e, "A")).join();
  }

  String next() {
    _index += 1;
    _value = _valueForIndex(_index);
    return _value;
  }

  String get current => _value;

  /// Excel-Like index => index split list
  /// § (26,26) => [0,0] => "AA"
  static List<int> branchingIndex(int value, int ceil) {
    if (value < 0) return [];
    return [...branchingIndex((value / ceil).floor() - 1, ceil), value % ceil];
  }
}
