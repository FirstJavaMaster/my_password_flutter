import 'package:intl/intl.dart';

class DateTimeUtils {
  static int getPrimaryKey() {
    DateTime now = DateTime.now();
    print(now);

    String firstPart = DateFormat('yyyyMMddhhmmssSSSSSS').format(now);
    print(firstPart);

    return 0;
  }
}
