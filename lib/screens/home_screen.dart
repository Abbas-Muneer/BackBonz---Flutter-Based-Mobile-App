import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/time_formatter.dart';
import '../providers/auth_provider.dart';
import '../providers/session_provider.dart';
import '../providers/timer_provider.dart';
import '../screen_helpers.dart';
import '../widgets/empty_state.dart';
import '../widgets/session_card.dart';
import '../widgets/timer_display.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _handleStop(BuildContext context) async {
    final timerProvider = context.read<TimerProvider>();
    final success = await timerProvider.stop();

    if (!context.mounted) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);

    if (success) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Session saved for today.')),
      );
    } else if (timerProvider.errorMessage != null) {
      messenger.showSnackBar(
        SnackBar(content: Text(timerProvider.errorMessage!)),
      );
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.signOut();

    if (!context.mounted) {
      return;
    }

    if (!success && authProvider.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(authProvider.errorMessage!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScreen(
      appBar: AppBar(
        title: const Text('BackBonz'),
        actions: [
          TextButton.icon(
            onPressed: () => _handleLogout(context),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Logout'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      child: Consumer3<AuthProvider, SessionProvider, TimerProvider>(
        builder: (context, authProvider, sessionProvider, timerProvider, _) {
          final email = authProvider.user?.email ?? 'friend';

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceAlt,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'Consistency matters',
                          style: TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Welcome back,',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Small, steady sessions build strong brace habits over time.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const TimerDisplay(),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed:
                                  timerProvider.isRunning ||
                                      timerProvider.isSaving
                                  ? null
                                  : timerProvider.start,
                              child: const Text('Start'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed:
                                  timerProvider.isRunning &&
                                      !timerProvider.isSaving
                                  ? timerProvider.pause
                                  : null,
                              child: const Text('Pause'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                foregroundColor: AppColors.textPrimary,
                              ),
                              onPressed:
                                  timerProvider.hasStarted &&
                                      !timerProvider.isSaving
                                  ? () => _handleStop(context)
                                  : null,
                              child: timerProvider.isSaving
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Stop'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Today total',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              TimeFormatter.formatSummary(
                                sessionProvider.todayTotal,
                              ),
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Completed sessions',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              sessionProvider.sessions.length.toString(),
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Today\'s sessions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Newest sessions appear first after you stop the timer.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              if (sessionProvider.isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 48),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (sessionProvider.errorMessage != null)
                EmptyState(
                  title: 'Sessions unavailable',
                  message: sessionProvider.errorMessage!,
                  icon: Icons.cloud_off_rounded,
                )
              else if (sessionProvider.sessions.isEmpty)
                const EmptyState(
                  title: 'No completed sessions yet today',
                  message:
                      'Start the timer when your brace session begins, then stop it to save progress.',
                  icon: Icons.hourglass_bottom_rounded,
                )
              else
                ...sessionProvider.sessions.map(SessionCard.new),
            ],
          );
        },
      ),
    );
  }
}
