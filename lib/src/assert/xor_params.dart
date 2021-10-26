import 'package:ltogt_utils/ltogt_utils.dart';

/// Assert that exatly one of [params] is not null
@Deprecated("Use oneNotNull instead")
bool xorParams(List params) {
  return oneNotNull(params);
}
