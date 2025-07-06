import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'About App',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '⚔️ What is Hashira Training?',
              style: TextStyle(
                color: Colors.orangeAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'This app turns your daily discipline into a Demon Slayer training journey. '
                  'Complete your daily tasks to defeat inner demons and grow your streak.',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              '📈 How the Streak Works',
              style: TextStyle(
                color: Colors.orangeAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Each day you complete all tasks, your streak increases by 1 day.\n'
                  'Missing a day resets your streak to 0. Stay consistent to reach Hashira rank!',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              '🏅 Rank System',
              style: TextStyle(
                color: Colors.orangeAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your rank grows with your streak:\n\n'
                  '• 1–5 Days: Mizunoto\n'
                  '• 6–15 Days: Mizunoe\n'
                  '• 16–30 Days: Kanoto\n'
                  '• 31–50 Days: Kanoe\n'
                  '• 51–70 Days: Tsuchinoto\n'
                  '• 71–90 Days: Tsuchinoe\n'
                  '• 91–115 Days: Hinoto\n'
                  '• 116–140 Days: Hinoe\n'
                  '• 141–160 Days: Kinoto\n'
                  '• 161–179 Days: Kinoe\n'
                  '• 180+ Days: Hashira (Highest Rank!)',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              '🗡️ Demons Slain Points',
              style: TextStyle(
                color: Colors.orangeAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Every task you complete counts as 1 demon slain.\n'
                  'Locking all tasks daily adds to your total demons slain count.',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              '🌙 Inspiration',
              style: TextStyle(
                color: Colors.orangeAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Hashira Training is inspired by the discipline and ranks from Demon Slayer. '
                  'Forge your soul daily and become a Hashira in real life!',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
