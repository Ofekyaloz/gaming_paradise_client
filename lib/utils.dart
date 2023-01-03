import 'package:flutter/foundation.dart' show kIsWeb;

class Constants {
  static String url =
      kIsWeb ? 'http://localhost:8000/api/' : 'http://10.0.2.2:8000/api/';

  static String? username;

}
