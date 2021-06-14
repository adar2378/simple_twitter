import 'package:intl/intl.dart';

class DateTimeFormatter {
  static String formatDateTime(DateTime dateTime, {DateFormat? format}) {
    format ??= DateFormat.jm();
    final dateFormat = DateFormat.yMd();
    final time = format.format(dateTime);
    final date = dateFormat.format(dateTime);
    return '$time, $date';
  }
}
