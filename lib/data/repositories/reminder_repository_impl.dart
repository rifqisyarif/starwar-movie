
import 'package:startwar_movie_app/data/datasource/reminder_local_datasource.dart';
import 'package:startwar_movie_app/domain/entities/reminder.dart';
import 'package:startwar_movie_app/domain/repositories/reminder_repository.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  final ReminderLocalDataSource localDataSource;

  ReminderRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<List<Reminder>> getReminders() {
    return localDataSource.getReminders();
  }

  @override
  Future<void> scheduleReminder(Reminder reminder) {
    return localDataSource.saveReminder(reminder);
  }

  @override
  Future<void> cancelReminder(String reminderId) {
    return localDataSource.deleteReminder(reminderId);
  }
}
