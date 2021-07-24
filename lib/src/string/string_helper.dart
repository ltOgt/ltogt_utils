class StringHelper {
  StringHelper._();
  static bool isFilled(String? s) => s != null && s.trim().isNotEmpty;
}
