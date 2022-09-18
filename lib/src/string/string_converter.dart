abstract class StringConverter {
  static String intListToString(List<int> ints) => ints.map((i) => "$i").join(",");
  static List<int> intListFromString(String string) => string.split(",").map((s) => int.parse(s)).toList();
}
