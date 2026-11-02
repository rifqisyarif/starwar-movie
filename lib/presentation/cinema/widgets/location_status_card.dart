import 'package:flutter/material.dart';
import 'package:startwar_movie_app/presentation/cinema/bloc/location/location_state.dart';
import 'package:startwar_movie_app/presentation/theme/app_theme.dart';

/// Compact location status card shown above the map.
class LocationStatusCard extends StatelessWidget {
  const LocationStatusCard({
    super.key,
    required this.state,
    required this.onRetry,
  });

  final LocationState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final (title, subtitle, icon, color) = switch (state) {
      LocationLoaded() => (
        'Location active',
        'Your position is shown on the map',
        Icons.my_location_rounded,
        AppColors.success,
      ),
      LocationLoading() => (
        'Locating...',
        'Finding your position',
        Icons.location_searching_rounded,
        AppColors.cyan,
      ),
      LocationError() => (
        'Location unavailable',
        (state as LocationError).message,
        Icons.location_off_rounded,
        AppColors.danger,
      ),
      _ => (
        'Waiting for location',
        'Allow access to see nearby cinemas',
        Icons.location_on_outlined,
        AppColors.textSecondary,
      ),
    };

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 11, 12, 11),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (state is LocationLoading) ...[
            const SizedBox(width: 8),
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ] else if (state is LocationLoaded) ...[
            const SizedBox(width: 8),
            Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
            ),
          ] else if (state is LocationError) ...[
            const SizedBox(width: 4),
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                minimumSize: const Size(0, 36),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                textStyle: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
}
