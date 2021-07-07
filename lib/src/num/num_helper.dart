class NumHelper {
  /// Returns a double with the specified precision.
  ///
  /// `toPrecision(4321.12345678, 3)` => `4321.123`
  /// `toPrecision(4321.12345678, 5)` => `4321.12346`
  static double toPrecision(num d, int p) {
    return num.parse(d.toStringAsFixed(p)).toDouble();
  }

  static String paddedString(int value, int maxForPaddingLength) {
    if (maxForPaddingLength < value) {
      throw "maxForPaddingLength must be larger than value! $maxForPaddingLength < $value";
    }

    int length = maxForPaddingLength.toString().length;
    String v = value.toString();
    return ("0" * (length - v.length)) + v;
  }
}
