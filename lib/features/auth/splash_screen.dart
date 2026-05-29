import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Shown while the session is being restored on launch.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.deepForest,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Lumenta',
              style: TextStyle(
                color: AppColors.onDarkHigh,
                fontSize: 28,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.signal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
