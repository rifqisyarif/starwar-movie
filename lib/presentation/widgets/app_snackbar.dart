import 'package:flutter/material.dart';
import 'package:startwar_movie_app/presentation/theme/app_theme.dart';

/// Shows a consistently themed floating snack bar.
///
/// Styling is applied explicitly because the app's [ScaffoldMessenger] sits
/// above the presentation-level theme.
void showAppSnackBar(
  BuildContext context, {
  required String message,
  IconData icon = Icons.info_outline_rounded,
  String? actionLabel,
  VoidCallback? onAction,
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: AppColors.surfaceHigh,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0x1AFFFFFF)),
        ),
        content: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.gold),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13.5,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
        action: actionLabel == null
            ? null
            : SnackBarAction(
                label: actionLabel,
                textColor: AppColors.gold,
                onPressed: onAction ?? () {},
              ),
      ),
    );
}
