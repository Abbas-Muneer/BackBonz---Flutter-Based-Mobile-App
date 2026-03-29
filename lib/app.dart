import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/session_provider.dart';
import 'providers/timer_provider.dart';
import 'screens/firebase_setup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';
import 'services/auth_service.dart';
import 'services/session_service.dart';

class BackBonzApp extends StatelessWidget {
  const BackBonzApp({super.key, this.bootstrapError});

  final String? bootstrapError;

  @override
  Widget build(BuildContext context) {
    final authService = FirebaseAuthService(FirebaseAuth.instance);
    final sessionService = FirestoreSessionService(FirebaseFirestore.instance);

    return MultiProvider(
      providers: [
        Provider<AuthService>.value(value: authService),
        Provider<SessionService>.value(value: sessionService),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(authService),
        ),
        ChangeNotifierProxyProvider<SessionService, SessionProvider>(
          create: (context) => SessionProvider(context.read<SessionService>()),
          update: (_, service, provider) => provider!..updateService(service),
        ),
        ChangeNotifierProxyProvider<SessionService, TimerProvider>(
          create: (context) => TimerProvider(context.read<SessionService>()),
          update: (_, service, provider) => provider!..updateService(service),
        ),
      ],
      child: MaterialApp(
        title: 'BackBonz',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.build(),
        home: bootstrapError == null
            ? const AppView()
            : FirebaseSetupScreen(message: bootstrapError!),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<AuthProvider, SessionProvider, TimerProvider>(
      builder: (context, authProvider, sessionProvider, timerProvider, _) {
        sessionProvider.updateUser(authProvider.user?.uid);
        timerProvider.updateUser(authProvider.user?.uid);

        if (authProvider.isInitializing) {
          return const SplashScreen();
        }

        if (authProvider.user == null) {
          return const LoginScreen();
        }

        return const HomeScreen();
      },
    );
  }
}
