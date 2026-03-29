import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/time_formatter.dart';
import '../providers/timer_provider.dart';

class TimerDisplay extends StatelessWidget {
  const TimerDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerProvider>(
      builder: (context, timerProvider, _) {
        final status = timerProvider.isRunning
            ? 'Session running'
            : timerProvider.hasStarted
            ? 'Paused'
            : 'Ready to begin';

        return Column(
          children: [
            Text(
              status,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 18),
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Text(
                TimeFormatter.formatDuration(timerProvider.elapsedDuration),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -1.2,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
