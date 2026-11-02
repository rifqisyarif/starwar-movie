import 'package:event_bus/event_bus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startwar_movie_app/core/events/app_events.dart';
import 'package:startwar_movie_app/domain/repositories/reminder_repository.dart';
import 'package:startwar_movie_app/presentation/reminder/bloc/reminder_event.dart';
import 'package:startwar_movie_app/presentation/reminder/bloc/reminder_state.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  final ReminderRepository repository;
  final EventBus eventBus;

  ReminderBloc({
    required this.repository,
    required this.eventBus,
  }) : super(ReminderInitial()) {
    on<LoadRemindersEvent>(_onLoadReminders);
    on<ScheduleReminderEvent>(_onScheduleReminder);
    on<CancelReminderEvent>(_onCancelReminder);
  }

  Future<void> _onLoadReminders(
    LoadRemindersEvent event,
    Emitter<ReminderState> emit,
  ) async {
    emit(ReminderLoading());

    try {
      final reminders = await repository.getReminders();
      emit(ReminderLoaded(reminders));
    } catch (e) {
      emit(ReminderError(e.toString()));
    }
  }

  Future<void> _onScheduleReminder(
    ScheduleReminderEvent event,
    Emitter<ReminderState> emit,
  ) async {
    try {
      await repository.scheduleReminder(event.reminder);

      final reminders = await repository.getReminders();

      emit(ReminderLoaded(reminders));

      eventBus.fire(
        ReminderScheduled(
          cinemaId: event.reminder.cinemaId,
          filmDetail: event.reminder.filmDetail,
          scheduledAt: event.reminder.scheduledAt,
        ),
      );
    } catch (e) {
      emit(ReminderError(e.toString()));
    }
  }

  Future<void> _onCancelReminder(
    CancelReminderEvent event,
    Emitter<ReminderState> emit,
  ) async {
    try {
      await repository.cancelReminder(event.reminderId);

      final reminders = await repository.getReminders();

      emit(ReminderLoaded(reminders));

      eventBus.fire(
        ReminderCancelled(
          cinemaId: event.cinemaId,
        ),
      );
    } catch (e) {
      emit(ReminderError(e.toString()));
    }
  }
}