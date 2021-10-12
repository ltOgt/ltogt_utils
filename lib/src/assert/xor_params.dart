/// Assert that exatly one of [params] is not null
bool xorParams(List params) {
  return params.where((p) => p != null).length == 1;
}
