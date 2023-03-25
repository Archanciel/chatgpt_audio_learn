
import 'package:intl/intl.dart';

extension FormattedDayHourMinute on Duration {
  static final NumberFormat numberFormatTwoInt = NumberFormat('00');

  // ignore: non_constant_identifier_names
  /// returns the Duration formatted as HH:mm
  String HHmm() {
    int durationMinute = inMinutes.remainder(60);
    String minusStr = '';

    if (inMinutes < 0) {
      minusStr = '-';
    }

    return "$minusStr${inHours.abs()}:${numberFormatTwoInt.format(durationMinute.abs())}";
  }

  /// returns the Duration formatted as HH:mm
  String HHmmss() {
    int durationMinute = inMinutes.remainder(60);
    int durationSecond = inSeconds.remainder(60);
    String minusStr = '';

    if (inMinutes < 0) {
      minusStr = '-';
    }

    return "$minusStr${inHours.abs()}:${numberFormatTwoInt.format(durationMinute.abs())}:${numberFormatTwoInt.format(durationSecond.abs())}";
  }

  /// returns the Duration formatted as dd:HH:mm
  String ddHHmm() {
    int durationMinute = inMinutes.remainder(60);
    String minusStr = '';
    int durationHour =
        Duration(minutes: (inMinutes - durationMinute)).inHours.remainder(24);
    int durationDay = Duration(hours: (inHours - durationHour)).inDays;

    if (inMinutes < 0) {
      minusStr = '-';
    }

    return "$minusStr${numberFormatTwoInt.format(durationDay.abs())}:${numberFormatTwoInt.format(durationHour.abs())}:${numberFormatTwoInt.format(durationMinute.abs())}";
  }
}
