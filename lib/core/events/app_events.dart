import 'package:startwar_movie_app/domain/entities/reminder.dart';

/// Fired whenever the persisted reminder list changes.
class RemindersChanged {
  const RemindersChanged(this.reminders);

  final List<Reminder> reminders;
}
