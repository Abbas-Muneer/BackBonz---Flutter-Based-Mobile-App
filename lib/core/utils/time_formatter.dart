import 'package:intl/intl.dart';

class TimeFormatter {
  static String formatDuration(Duration duration) {
    final totalSeconds = duration.inSeconds;
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    return '${_pad(hours)}:${_pad(minutes)}:${_pad(seconds)}';
  }

  static String formatSummary(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours == 0 && minutes == 0) {
      return '0m';
    }
    if (hours == 0) {
      return '${minutes}m';
    }
    if (minutes == 0) {
      return '${hours}h';
    }
    return '${hours}h ${minutes}m';
  }

  static String formatClock(DateTime value) {
    return DateFormat('h:mm a').format(value);
  }

  static String formatDateKey(DateTime value) {
    return DateFormat('yyyy-MM-dd').format(value);
  }

  static String _pad(int value) => value.toString().padLeft(2, '0');
}
