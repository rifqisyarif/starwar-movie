import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:startwar_movie_app/domain/entities/reminder.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ReminderNotificationService {
  ReminderNotificationService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const String _channelId = 'movie_reminders';
  static const String _channelName = 'Movie reminders';
  static const String _channelDescription =
      'Notifications for scheduled movie reminders.';

  final FlutterLocalNotificationsPlugin _plugin;

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    try {
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: androidSettings,
          iOS: darwinSettings,
          macOS: darwinSettings,
        ),
      );
      _initialized = true;
    } catch (error, stackTrace) {
      debugPrint('Failed to initialize reminder notifications: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> scheduleReminder(Reminder reminder) async {
    try {
      await initialize();
      if (!_initialized) {
        return;
      }

      await _requestPermissions();

      final scheduledDate = tz.TZDateTime.from(reminder.scheduledAt, tz.UTC);
      if (!scheduledDate.isAfter(tz.TZDateTime.now(tz.UTC))) {
        return;
      }

      final movieTitle = reminder.filmDetail.title ?? 'Your movie';
      final time = DateFormat.jm().format(reminder.scheduledAt);

      final notificationDetails = NotificationDetails(
        android: const AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
          category: AndroidNotificationCategory.reminder,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      final notificationId = _notificationIdFor(reminder.id);

      try {
        await _plugin.zonedSchedule(
          id: notificationId,
          title: 'Movie reminder',
          body: '$movieTitle starts at $time',
          scheduledDate: scheduledDate,
          notificationDetails: notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: reminder.id,
        );
      } catch (_) {
        // Exact alarms may be unavailable on Android 14+ without user consent.
        await _plugin.zonedSchedule(
          id: notificationId,
          title: 'Movie reminder',
          body: '$movieTitle starts at $time',
          scheduledDate: scheduledDate,
          notificationDetails: notificationDetails,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          payload: reminder.id,
        );
      }
    } catch (error, stackTrace) {
      debugPrint('Failed to schedule reminder notification: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> cancelReminder(String reminderId) async {
    try {
      await initialize();
      if (!_initialized) {
        return;
      }

      await _plugin.cancel(id: _notificationIdFor(reminderId));
    } catch (error, stackTrace) {
      debugPrint('Failed to cancel reminder notification: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> _requestPermissions() async {
    if (kIsWeb) {
      return;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  int _notificationIdFor(String reminderId) {
    // Stable 31-bit hash so the same reminder can be cancelled later.
    var hash = 0x811C9DC5;
    for (final codeUnit in reminderId.codeUnits) {
      hash ^= codeUnit;
      hash = (hash * 0x01000193) & 0x7FFFFFFF;
    }
    return hash;
  }
}
