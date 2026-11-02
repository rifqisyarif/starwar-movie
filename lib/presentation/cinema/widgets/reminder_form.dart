import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:startwar_movie_app/presentation/theme/app_theme.dart';

class ReminderForm extends StatefulWidget {
  const ReminderForm({
    super.key,
    required this.movieTitle,
    required this.onSubmit,
    this.cinemaName,
  });

  final String movieTitle;
  final String? cinemaName;
  final Function(DateTime reminderTime) onSubmit;

  @override
  State<ReminderForm> createState() => _ReminderFormState();
}

class _ReminderFormState extends State<ReminderForm> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? _error;

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final result = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 2),
    );

    if (result != null) {
      setState(() {
        selectedDate = result;
        _error = null;
      });
    }
  }

  Future<void> _pickTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (result != null) {
      setState(() {
        selectedTime = result;
        _error = null;
      });
    }
  }

  DateTime? _getReminderDateTime() {
    if (selectedDate == null || selectedTime == null) {
      return null;
    }

    return DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );
  }

  void _submit() {
    final reminderTime = _getReminderDateTime();

    if (reminderTime == null) {
      setState(() => _error = 'Please choose both a date and a time.');
      return;
    }

    if (!reminderTime.isAfter(DateTime.now())) {
      setState(() => _error = 'Choose a time in the future.');
      return;
    }

    setState(() => _error = null);
    widget.onSubmit(reminderTime);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceHigh.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.local_movies_rounded,
                    size: 19,
                    color: AppColors.gold,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MOVIE',
                        style: AppTheme.label.copyWith(
                          fontSize: 8,
                          letterSpacing: 1.6,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.movieTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (widget.cinemaName != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          widget.cinemaName!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _SelectorTile(
            icon: Icons.calendar_month_rounded,
            label: 'DATE',
            value: selectedDate == null
                ? 'Choose a date'
                : DateFormat('EEE, dd MMM yyyy').format(selectedDate!),
            isPlaceholder: selectedDate == null,
            onTap: _pickDate,
          ),
          const SizedBox(height: 10),
          _SelectorTile(
            icon: Icons.access_time_rounded,
            label: 'TIME',
            value: selectedTime?.format(context) ?? 'Choose a time',
            isPlaceholder: selectedTime == null,
            onTap: _pickTime,
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 15,
                  color: AppColors.danger,
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    _error!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.danger,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.notifications_active_rounded, size: 19),
            label: const Text('Set Reminder'),
          ),
        ],
      ),
    );
  }
}

class _SelectorTile extends StatelessWidget {
  const _SelectorTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.isPlaceholder,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isPlaceholder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceHigh.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isPlaceholder
                  ? Colors.white.withValues(alpha: 0.07)
                  : AppColors.gold.withValues(alpha: 0.35),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: isPlaceholder
                    ? AppColors.textSecondary
                    : AppColors.gold,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTheme.label.copyWith(
                        fontSize: 8,
                        letterSpacing: 1.5,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: isPlaceholder
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 19,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
