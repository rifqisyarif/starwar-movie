import 'package:flutter/material.dart';

class ReminderForm extends StatefulWidget {
  final String movieTitle;
  final Function(DateTime reminderTime) onSubmit;

  const ReminderForm({
    super.key,
    required this.movieTitle,
    required this.onSubmit,
  });

  @override
  State<ReminderForm> createState() => _ReminderFormState();
}

class _ReminderFormState extends State<ReminderForm> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final result = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 2),
    );

    if (result != null) {
      setState(() => selectedDate = result);
    }
  }

  Future<void> _pickTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (result != null) {
      setState(() => selectedTime = result);
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date and time')),
      );
      return;
    }

    if (!reminderTime.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a future time')),
      );
      return;
    }

    widget.onSubmit(reminderTime);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Movie: ${widget.movieTitle}'),
    
        const SizedBox(height: 24),
    
        ListTile(
          leading: const Icon(Icons.calendar_month),
          title: const Text('Reminder date'),
          subtitle: Text(
            selectedDate == null
                ? 'Select date'
                : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: _pickDate,
        ),
    
        ListTile(
          leading: const Icon(Icons.access_time),
          title: const Text('Reminder time'),
          subtitle: Text(selectedTime?.format(context) ?? 'Select time'),
          trailing: const Icon(Icons.chevron_right),
          onTap: _pickTime,
        ),
    
        const SizedBox(height: 20),
    
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _submit,
            child: const Text('Set Reminder'),
          ),
        ),
      ],
    );
  }
}
