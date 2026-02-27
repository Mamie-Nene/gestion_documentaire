
class DateHelper {
  static String getFormattedDuration(String start, String end) {
    final startTime = DateTime.parse(start);
    final endTime = DateTime.parse(end);

    final difference = endTime.difference(startTime);

    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);

    if (hours == 0) {
      return "$minutes min";
    }

    if (minutes == 0) {
      return "$hours h";
    }

    return "${hours}h ${minutes}min";
  }
}
class DateHelperSimple {
  int getDurationInMinutes(String start, String end) {
    final startTime = DateTime.parse(start);
    final endTime = DateTime.parse(end);

    return endTime.difference(startTime).inMinutes;
  }
}
class DateHelperWithMillisecond {
  static int getDurationInMinutes(String start, String end) {
    final startTime = DateTime.parse(start);
    final endTime = DateTime.parse(end);

    return endTime.difference(startTime).inMinutes;
  }
}