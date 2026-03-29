import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/wear_session.dart';
import '../services/session_service.dart';

class SessionProvider extends ChangeNotifier {
  SessionProvider(this._sessionService);

  SessionService _sessionService;
  StreamSubscription<List<WearSession>>? _subscription;
  List<WearSession> _sessions = const [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _userId;

  List<WearSession> get sessions => _sessions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Duration get todayTotal => Duration(
    seconds: _sessions.fold<int>(
      0,
      (total, session) => total + session.durationSeconds,
    ),
  );

  void updateService(SessionService service) {
    _sessionService = service;
  }

  void updateUser(String? userId) {
    if (_userId == userId) {
      return;
    }

    _userId = userId;
    _errorMessage = null;
    _sessions = const [];
    _subscription?.cancel();

    if (userId == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    _subscription = _sessionService
        .watchTodaySessions(
          userId: userId,
          startOfDay: startOfDay,
          endOfDay: endOfDay,
        )
        .listen(
          (sessions) {
            _sessions = sessions;
            _isLoading = false;
            _errorMessage = null;
            notifyListeners();
          },
          onError: (_) {
            _sessions = const [];
            _isLoading = false;
            _errorMessage =
                'Today\'s sessions could not be loaded right now. Please try again.';
            notifyListeners();
          },
        );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
