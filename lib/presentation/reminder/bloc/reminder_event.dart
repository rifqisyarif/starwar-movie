import 'package:startwar_movie_app/domain/entities/reminder.dart';

abstract class ReminderEvent {}

class LoadRemindersEvent extends ReminderEvent {}

class ScheduleReminderEvent extends ReminderEvent {
  final Reminder reminder;

  ScheduleReminderEvent(this.reminder);
}

class CancelReminderEvent extends ReminderEvent {
  final String reminderId;

  CancelReminderEvent({required this.reminderId});
}
