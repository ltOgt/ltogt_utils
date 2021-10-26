/// Check if exatly one of [params] is not null
bool oneNotNull(List params) {
  // . works for [] => always false (-1)
  // . works for [<one>] => zero null (0)
  return countNull(params, params.length - 1);
}

/// Check if exactly one of [params] is null
bool oneNull(List params) {
  return countNull(params, 1);
}

/// Check if none of [params] are null
bool noneNull(List params) {
  return countNull(params, 0);
}

/// Check if all of [params] are null
bool allNull(List params) {
  return countNull(params, params.length);
}

/// Check if [count] number of [params] are null
bool countNull(List params, int count) {
  return params.where((p) => p == null).length == count;
}
