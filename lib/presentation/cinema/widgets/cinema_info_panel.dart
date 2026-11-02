import 'package:flutter/material.dart';
import 'package:startwar_movie_app/domain/entities/cinema.dart';
import 'package:startwar_movie_app/presentation/cinema/bloc/route/route_state.dart';
import 'package:startwar_movie_app/presentation/theme/app_theme.dart';

/// Floating bottom sheet with cinema details and route actions.
class CinemaInfoPanel extends StatelessWidget {
  const CinemaInfoPanel({
    super.key,
    required this.cinema,
    required this.routeState,
    required this.hasLocation,
    required this.isLocating,
    required this.onCheckRoute,
    required this.onClearRoute,
    required this.onSetReminder,
  });

  final Cinema? cinema;
  final RouteState routeState;
  final bool hasLocation;
  final bool isLocating;
  final VoidCallback onCheckRoute;
  final VoidCallback onClearRoute;
  final VoidCallback onSetReminder;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.97),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.45),
              blurRadius: 32,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: cinema == null
            ? const _EmptyPanel()
            : _SelectedPanel(
                cinema: cinema!,
                routeState: routeState,
                hasLocation: hasLocation,
                isLocating: isLocating,
                onCheckRoute: onCheckRoute,
                onClearRoute: onClearRoute,
                onSetReminder: onSetReminder,
              ),
      ),
    );
  }
}

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.22)),
          ),
          child: const Icon(
            Icons.touch_app_rounded,
            color: AppColors.gold,
            size: 21,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'EXPLORE CINEMAS',
                style: AppTheme.label.copyWith(fontSize: 9, letterSpacing: 1.8),
              ),
              const SizedBox(height: 5),
              Text(
                'Tap a marker on the map to see cinema details and plan your visit.',
                style: AppTheme.body.copyWith(fontSize: 12.5, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SelectedPanel extends StatelessWidget {
  const _SelectedPanel({
    required this.cinema,
    required this.routeState,
    required this.hasLocation,
    required this.isLocating,
    required this.onCheckRoute,
    required this.onClearRoute,
    required this.onSetReminder,
  });

  final Cinema cinema;
  final RouteState routeState;
  final bool hasLocation;
  final bool isLocating;
  final VoidCallback onCheckRoute;
  final VoidCallback onClearRoute;
  final VoidCallback onSetReminder;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.gold.withValues(alpha: 0.24),
                ),
              ),
              child: const Icon(
                Icons.local_movies_rounded,
                color: AppColors.gold,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SELECTED CINEMA',
                    style: AppTheme.label.copyWith(
                      fontSize: 8.5,
                      letterSpacing: 1.8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cinema.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.title.copyWith(fontSize: 17),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._buildRouteContent(context),
      ],
    );
  }

  List<Widget> _buildRouteContent(BuildContext context) {
    if (routeState is RouteLoaded) {
      final route = (routeState as RouteLoaded).route;

      return [
        Row(
          children: [
            Expanded(
              child: _RouteMetric(
                icon: Icons.route_rounded,
                label: 'DISTANCE',
                value: '${(route.distance / 1000).toStringAsFixed(2)} km',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _RouteMetric(
                icon: Icons.schedule_rounded,
                label: 'ETA',
                value: '${(route.duration / 60).ceil()} min',
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onClearRoute,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 48),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                icon: const Icon(Icons.close_rounded, size: 17),
                label: const Text('Clear'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton.icon(
                onPressed: onSetReminder,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 48),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                icon: const Icon(
                  Icons.notifications_active_rounded,
                  size: 17,
                ),
                label: const Text('Remind'),
              ),
            ),
          ],
        ),
      ];
    }

    if (routeState is RouteLoading) {
      return [
        Row(
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Calculating route...',
                style: AppTheme.body.copyWith(fontSize: 13),
              ),
            ),
            const SizedBox(width: 10),
            _CloseButton(onPressed: onClearRoute),
          ],
        ),
      ];
    }

    if (routeState is RouteError) {
      return [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.danger.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.danger.withValues(alpha: 0.22),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 16,
                color: AppColors.danger,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  (routeState as RouteError).message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.danger,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _RouteButton(
          onPressed: hasLocation ? onCheckRoute : null,
          icon: Icons.refresh_rounded,
          label: 'Try again',
          onClose: onClearRoute,
        ),
      ];
    }

    final hint = isLocating
        ? 'Finding your location so we can calculate the route...'
        : hasLocation
        ? 'Get distance and estimated travel time from your current location.'
        : 'Enable location access to calculate a route to this cinema.';

    return [
      Text(
        hint,
        style: AppTheme.body.copyWith(fontSize: 12.5, height: 1.4),
      ),
      const SizedBox(height: 14),
      _RouteButton(
        onPressed: hasLocation ? onCheckRoute : null,
        icon: isLocating
            ? Icons.location_searching_rounded
            : Icons.alt_route_rounded,
        label: isLocating ? 'Locating...' : 'Check Route',
        onClose: onClearRoute,
      ),
    ];
  }
}

class _RouteButton extends StatelessWidget {
  const _RouteButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    this.onClose,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final button = FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 19),
      label: Text(label),
    );

    if (onClose == null) {
      return SizedBox(width: double.infinity, child: button);
    }

    return Row(
      children: [
        Expanded(child: button),
        const SizedBox(width: 10),
        _CloseButton(onPressed: onClose!),
      ],
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: 'Close',
      icon: const Icon(Icons.close_rounded, size: 20),
      style: IconButton.styleFrom(
        backgroundColor: AppColors.surfaceHigh,
        foregroundColor: AppColors.textSecondary,
        minimumSize: const Size(52, 52),
        maximumSize: const Size(52, 52),
        padding: EdgeInsets.zero,
        side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class _RouteMetric extends StatelessWidget {
  const _RouteMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 17, color: AppColors.gold),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.label.copyWith(
                    fontSize: 7.5,
                    letterSpacing: 1.4,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
