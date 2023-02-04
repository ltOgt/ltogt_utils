class NumHelper {
  NumHelper._();

  /// Returns a double with the specified precision.
  ///
  /// `toPrecision(4321.12345678, 3)` => `4321.123`
  /// `toPrecision(4321.12345678, 5)` => `4321.12346`
  static double toPrecision(num d, int p) {
    return num.parse(d.toStringAsFixed(p)).toDouble();
  }

  static String paddedString(int value, int maxForPaddingLength) {
    if ("$maxForPaddingLength".length < "$value".length) {
      throw Exception(
        "maxForPaddingLength lenght must be larger than value length! $maxForPaddingLength.length < $value.length",
      );
    }

    int length = maxForPaddingLength.toString().length;
    String v = value.toString();
    if (value < 0) {
      String _v = v.replaceFirst("-", "");
      return "-" + ("0" * (length - _v.length)) + _v;
    }
    return ("0" * (length - v.length)) + v;
  }

  // basically min-max scaling
  static double rescale({
    required double value,
    required double min,
    required double max,
    required double newMin,
    required double newMax,
    bool enforceNewBounds = false,
    bool enforceOldBounds = false,
  }) {
    assert(min <= max);
    assert(newMin <= newMax);

    final _value = enforceOldBounds ? bounded(value, min, max) : value;

    final _scaled = ((_value - min) / (max - min)) * (newMax - newMin) + newMin;

    return enforceNewBounds ? bounded(_scaled, newMin, newMax) : _scaled;
  }

  static bool isBetween(double val, double? min, double? max) {
    assert((min ?? double.negativeInfinity) <= (max ?? double.infinity));
    return (val >= (min ?? double.negativeInfinity) && val <= (max ?? double.infinity));
  }

  static T bounded<T extends num>(T value, T min, T max) {
    assert(min <= max);
    return smaller(max, larger(min, value));
  }

  static T smaller<T extends num>(T a, T b) => a < b ? a : b;
  static T larger<T extends num>(T a, T b) => a > b ? a : b;
}
