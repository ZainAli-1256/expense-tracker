import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Summary screen for Phase 2 (charts and analytics)
/// Currently placeholder for future implementation
class SummaryScreen extends StatelessWidget {
  const SummaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: const Text('Summary'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics_outlined, size: 64, color: AppTheme.textMuted),
            const SizedBox(height: 16),
            Text(
              'Summary & Analytics',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: AppTheme.textLight),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming in Phase 2',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
