import 'dart:io';

import 'package:flutter/foundation.dart';


class GBL {
  static bool get isDesktop => !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);

}