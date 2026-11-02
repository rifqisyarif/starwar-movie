import 'package:flutter/material.dart';
import 'package:startwar_movie_app/presentation/theme/app_theme.dart';

/// Uppercase section heading with a short gold rule.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.trailing});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 1.5,
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(text.toUpperCase(), style: AppTheme.label),
        if (trailing != null) ...[
          const SizedBox(width: 12),
          Expanded(child: trailing!),
        ],
      ],
    );
  }
}
