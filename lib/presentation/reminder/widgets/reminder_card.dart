import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:startwar_movie_app/domain/entities/reminder.dart';
import 'package:startwar_movie_app/presentation/theme/app_theme.dart';
import 'package:startwar_movie_app/presentation/widgets/roman_numeral.dart';

class ReminderCard extends StatelessWidget {
  const ReminderCard({
    super.key,
    required this.reminder,
    required this.onCancel,
  });

  final Reminder reminder;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final date = reminder.scheduledAt.toLocal();
    final roman = romanNumeral(reminder.filmDetail.episodeId);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.surface, AppColors.backgroundAlt],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.26),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DateBadge(date: date),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  roman.isEmpty ? 'REMINDER' : 'EPISODE $roman',
                  style: AppTheme.label.copyWith(
                    fontSize: 8.5,
                    letterSpacing: 1.7,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reminder.filmDetail.title ?? 'Unknown movie',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.title.copyWith(fontSize: 15.5),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      size: 14,
                      color: AppColors.gold,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat('hh:mm a').format(date),
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Container(
                      width: 3,
                      height: 3,
                      decoration: const BoxDecoration(
                        color: AppColors.textMuted,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        DateFormat('EEEE').format(date),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            onPressed: onCancel,
            tooltip: 'Cancel reminder',
            icon: const Icon(Icons.notifications_off_outlined, size: 18),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.surfaceHigh,
              foregroundColor: AppColors.textSecondary,
              minimumSize: const Size.square(36),
              maximumSize: const Size.square(36),
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateBadge extends StatelessWidget {
  const _DateBadge({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 66,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.gold.withValues(alpha: 0.18),
            AppColors.surfaceHigh.withValues(alpha: 0.8),
          ],
        ),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.22)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('MMM').format(date).toUpperCase(),
            style: AppTheme.label.copyWith(
              fontSize: 8,
              letterSpacing: 1.4,
              color: AppColors.gold,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            DateFormat('dd').format(date),
            style: const TextStyle(
              fontSize: 22,
              height: 1.1,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            DateFormat('EEE').format(date).toUpperCase(),
            style: const TextStyle(
              fontSize: 7.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
