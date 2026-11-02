import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:startwar_movie_app/presentation/theme/app_theme.dart';

/// A fixed deep-space backdrop used behind every screen.
///
/// The stars are painted with a deterministic seed so the background does not
/// flicker between rebuilds.
class StarfieldBackground extends StatelessWidget {
  const StarfieldBackground({
    super.key,
    required this.child,
    this.showNebula = true,
  });

  final Widget child;
  final bool showNebula;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF101A33), AppColors.background],
              stops: [0.0, 0.72],
            ),
          ),
        ),
        if (showNebula) ...[
          Positioned(
            top: -140,
            right: -120,
            child: _Glow(
              color: AppColors.cyan.withValues(alpha: 0.16),
              size: 360,
            ),
          ),
          Positioned(
            bottom: -180,
            left: -160,
            child: _Glow(
              color: AppColors.gold.withValues(alpha: 0.10),
              size: 420,
            ),
          ),
        ],
        const Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(painter: _StarfieldPainter()),
          ),
        ),
        child,
      ],
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
        ),
      ),
    );
  }
}

class _StarfieldPainter extends CustomPainter {
  const _StarfieldPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42);
    final starCount = math.max(70, (size.width * size.height / 5200).round());

    for (var i = 0; i < starCount; i++) {
      final offset = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );
      final radius = 0.35 + random.nextDouble() * 1.25;
      final opacity = 0.14 + random.nextDouble() * 0.62;

      final paint = Paint()..color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(offset, radius, paint);

      if (i % 41 == 0) {
        final glowPaint = Paint()
          ..color = AppColors.goldBright.withValues(alpha: 0.55)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);
        canvas.drawCircle(offset, radius + 0.6, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _StarfieldPainter oldDelegate) => false;
}
