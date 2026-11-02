import 'package:startwar_movie_app/domain/entities/reminder.dart';

abstract class ReminderRepository {
  Future<List<Reminder>> getReminders();

  Future<void> scheduleReminder(Reminder reminder);

  Future<void> cancelReminder(String reminderId);
}