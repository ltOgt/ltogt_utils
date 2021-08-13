import 'package:ltogt_utils/ltogt_utils.dart';

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
    required double max,
    required double min,
    required double newMax,
    required double newMin,
  }) {
    return ((value - min) / (max - min)) * (newMax - newMin) + newMin;
  }

  static bool isBetween(double val, double? min, double? max) {
    return (val >= (min ?? double.negativeInfinity) && val <= (max ?? double.infinity));
  }
}
