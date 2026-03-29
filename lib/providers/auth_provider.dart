import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._authService) {
    _subscription = _authService.authStateChanges().listen((user) {
      _user = user;
      _isInitializing = false;
      notifyListeners();
    });
  }

  final AuthService _authService;
  late final StreamSubscription<User?> _subscription;

  User? _user;
  bool _isInitializing = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isInitializing => _isInitializing;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;

  Future<bool> signIn({required String email, required String password}) async {
    return _runAuthAction(
      () => _authService.signIn(email: email, password: password),
    );
  }

  Future<bool> signUp({required String email, required String password}) async {
    return _runAuthAction(
      () => _authService.signUp(email: email, password: password),
    );
  }

  Future<bool> signOut() async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signOut();
      return true;
    } on AuthFailure catch (error) {
      _errorMessage = error.message;
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> _runAuthAction(Future<void> Function() action) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await action();
      return true;
    } on AuthFailure catch (error) {
      _errorMessage = error.message;
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
