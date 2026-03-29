import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/wear_session.dart';
import '../services/session_service.dart';

class TimerProvider extends ChangeNotifier {
  TimerProvider(this._sessionService, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  SessionService _sessionService;
  final DateTime Function() _clock;
  Timer? _ticker;
  String? _userId;
  DateTime? _sessionStartTime;
  DateTime? _initialSessionStartTime;
  Duration _accumulatedDuration = Duration.zero;
  bool _isRunning = false;
  bool _isSaving = false;
  String? _errorMessage;

  bool get isRunning => _isRunning;
  bool get isSaving => _isSaving;
  bool get hasStarted =>
      _initialSessionStartTime != null || _accumulatedDuration > Duration.zero;
  String? get errorMessage => _errorMessage;

  Duration get elapsedDuration {
    if (!_isRunning || _sessionStartTime == null) {
      return _accumulatedDuration;
    }

    return _accumulatedDuration + _clock().difference(_sessionStartTime!);
  }

  void updateService(SessionService service) {
    _sessionService = service;
  }

  void updateUser(String? userId) {
    if (_userId == userId) {
      return;
    }

    _userId = userId;
    reset();
  }

  void start() {
    if (_isRunning) {
      return;
    }

    final now = _clock();
    _initialSessionStartTime ??= now;
    _sessionStartTime = now;
    _isRunning = true;
    _errorMessage = null;
    _startTicker();
    notifyListeners();
  }

  void pause() {
    if (!_isRunning || _sessionStartTime == null) {
      return;
    }

    _accumulatedDuration += _clock().difference(_sessionStartTime!);
    _sessionStartTime = null;
    _isRunning = false;
    _ticker?.cancel();
    notifyListeners();
  }

  Future<bool> stop() async {
    if (!hasStarted || _userId == null || _initialSessionStartTime == null) {
      return false;
    }

    if (_isRunning && _sessionStartTime != null) {
      _accumulatedDuration += _clock().difference(_sessionStartTime!);
    }

    final endTime = _clock();
    final finalDuration = _accumulatedDuration;

    _ticker?.cancel();
    _isRunning = false;
    _sessionStartTime = null;

    if (finalDuration.inSeconds <= 0) {
      reset();
      return false;
    }

    final session = WearSession(
      id: '',
      userId: _userId!,
      startTime: _initialSessionStartTime!,
      endTime: endTime,
      durationSeconds: finalDuration.inSeconds,
      dateKey: _sessionService.dateKeyFor(endTime),
    );

    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _sessionService.saveSession(session);
      reset(notify: false);
      return true;
    } on SessionFailure catch (error) {
      _errorMessage = error.message;
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  void reset({bool notify = true}) {
    _ticker?.cancel();
    _sessionStartTime = null;
    _initialSessionStartTime = null;
    _accumulatedDuration = Duration.zero;
    _isRunning = false;
    _isSaving = false;
    _errorMessage = null;
    if (notify) {
      notifyListeners();
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
