import 'package:flutter/material.dart';
import 'package:startwar_movie_app/presentation/theme/app_theme.dart';

/// A compact rounded icon button used in app bars and overlays.
class GlassIconButton extends StatelessWidget {
  const GlassIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.foregroundColor,
    this.backgroundColor,
    this.size = 44,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon, size: size * 0.45),
      style: IconButton.styleFrom(
        backgroundColor:
            backgroundColor ?? AppColors.surface.withValues(alpha: 0.88),
        foregroundColor: foregroundColor ?? AppColors.textPrimary,
        disabledForegroundColor: AppColors.textMuted,
        minimumSize: Size.square(size),
        maximumSize: Size.square(size),
        padding: EdgeInsets.zero,
        side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size * 0.32),
        ),
      ),
    );
  }
}
