import 'package:backbonz/core/utils/time_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formats timer display as HH:MM:SS', () {
    expect(
      TimeFormatter.formatDuration(
        const Duration(hours: 2, minutes: 3, seconds: 4),
      ),
      '02:03:04',
    );
  });

  test('formats summary display', () {
    expect(
      TimeFormatter.formatSummary(const Duration(hours: 5, minutes: 30)),
      '5h 30m',
    );
  });
}
