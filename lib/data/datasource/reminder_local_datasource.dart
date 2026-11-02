import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:startwar_movie_app/data/models/movie_detail_model.dart';
import 'package:startwar_movie_app/data/services/reminder_notification_service.dart';
import 'package:startwar_movie_app/domain/entities/reminder.dart';

abstract class ReminderLocalDataSource {
  Future<List<Reminder>> getReminders();

  Future<void> saveReminder(Reminder reminder);

  Future<void> deleteReminder(String reminderId);
}

class ReminderLocalDataSourceImpl implements ReminderLocalDataSource {
  static const String _storageKey = 'movie_reminders';

  final SharedPreferences sharedPreferences;
  final ReminderNotificationService notificationService;

  ReminderLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.notificationService,
  });

  @override
  Future<List<Reminder>> getReminders() async {
    final jsonString = sharedPreferences.getString(_storageKey);

    if (jsonString == null) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(jsonString);

    return decoded.map((item) {
      final json = Map<String, dynamic>.from(item);

      return Reminder(
        id: json['id'],
        movieId: json['movieId'],
        cinemaId: json['cinemaId'],
        scheduledAt: DateTime.parse(json['scheduledAt']),
        filmDetail: MovieDetailModel.fromJson(
          Map<String, dynamic>.from(json['filmDetail']),
        ),
      );
    }).toList();
  }

  @override
  Future<void> saveReminder(Reminder reminder) async {
    final reminders = await getReminders();

    // Prevent duplicate reminders with the same ID.
    reminders.removeWhere((item) => item.id == reminder.id);

    reminders.add(reminder);

    final jsonString = jsonEncode(
      reminders.map((item) {
        return {
          'id': item.id,
          'movieId': item.movieId,
          'cinemaId': item.cinemaId,
          'scheduledAt': item.scheduledAt.toIso8601String(),
          'filmDetail': item.filmDetail.toJson(),
        };
      }).toList(),
    );

    await sharedPreferences.setString(_storageKey, jsonString);

    await notificationService.scheduleReminder(reminder);
  }

  @override
  Future<void> deleteReminder(String reminderId) async {
    final reminders = await getReminders();

    reminders.removeWhere((item) => item.id == reminderId);

    final jsonString = jsonEncode(
      reminders.map((item) {
        return {
          'id': item.id,
          'movieId': item.movieId,
          'cinemaId': item.cinemaId,
          'scheduledAt': item.scheduledAt.toIso8601String(),
          'filmDetail': item.filmDetail.toJson(),
        };
      }).toList(),
    );

    await sharedPreferences.setString(_storageKey, jsonString);

    await notificationService.cancelReminder(reminderId);
  }
}
