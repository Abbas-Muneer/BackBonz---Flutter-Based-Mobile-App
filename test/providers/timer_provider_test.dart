import 'package:backbonz/models/wear_session.dart';
import 'package:backbonz/providers/timer_provider.dart';
import 'package:backbonz/services/session_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('tracks elapsed time using timestamps and saves on stop', () async {
    final fakeSessionService = FakeSessionService();
    final clock = TestClock([
      DateTime(2026, 3, 26, 8, 0, 0),
      DateTime(2026, 3, 26, 8, 0, 5),
      DateTime(2026, 3, 26, 8, 0, 5),
      DateTime(2026, 3, 26, 8, 0, 8),
      DateTime(2026, 3, 26, 8, 0, 10),
      DateTime(2026, 3, 26, 8, 0, 10),
    ]);

    final provider = TimerProvider(fakeSessionService, clock: clock.next)
      ..updateUser('user-123');

    provider.start();
    expect(provider.elapsedDuration.inSeconds, 5);

    provider.pause();
    expect(provider.elapsedDuration.inSeconds, 5);

    provider.start();
    final saved = await provider.stop();

    expect(saved, isTrue);
    expect(fakeSessionService.savedSessions.single.durationSeconds, 7);
    expect(fakeSessionService.savedSessions.single.userId, 'user-123');
    expect(provider.elapsedDuration, Duration.zero);
  });
}

class FakeSessionService implements SessionService {
  final List<WearSession> savedSessions = [];

  @override
  String dateKeyFor(DateTime date) => '2026-03-26';

  @override
  Future<void> saveSession(WearSession session) async {
    savedSessions.add(session);
  }

  @override
  Stream<List<WearSession>> watchTodaySessions({
    required String userId,
    required String dateKey,
  }) {
    return const Stream.empty();
  }
}

class TestClock {
  TestClock(this._values);

  final List<DateTime> _values;
  int _index = 0;

  DateTime next() {
    final value = _values[_index];
    if (_index < _values.length - 1) {
      _index += 1;
    }
    return value;
  }
}
