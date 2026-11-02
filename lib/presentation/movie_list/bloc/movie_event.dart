import 'package:startwar_movie_app/domain/entities/reminder.dart';

sealed class MovieEvent {
  const MovieEvent();
}

class InitMovieEvent extends MovieEvent {
  const InitMovieEvent();
}

class LoadMovieEvent extends MovieEvent {
  const LoadMovieEvent();
}

class RefreshMovieRemindersEvent extends MovieEvent {
  final List<Reminder> reminders;

  const RefreshMovieRemindersEvent(this.reminders);
}
