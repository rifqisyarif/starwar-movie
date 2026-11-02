import 'package:flutter/material.dart';
import 'package:startwar_movie_app/presentation/theme/app_theme.dart';

class SagaHeader extends StatelessWidget {
  const SagaHeader({super.key, required this.filmCount});

  final int filmCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'A LONG TIME AGO IN A GALAXY FAR, FAR AWAY...',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.7,
            color: AppColors.gold.withValues(alpha: 0.72),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'The Skywalker\nSaga',
          style: AppTheme.display.copyWith(fontSize: 38),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Text(
              '$filmCount EPISODES',
              style: AppTheme.label.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.gold.withValues(alpha: 0.45),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.star_rounded,
              size: 14,
              color: AppColors.gold.withValues(alpha: 0.8),
            ),
          ],
        ),
      ],
    );
  }
}
