import 'package:flutter/foundation.dart' show kIsWeb;

bool isKsiWeb() {
  if(kIsWeb) {
    return true;
  } else {
    return false;
  }
}