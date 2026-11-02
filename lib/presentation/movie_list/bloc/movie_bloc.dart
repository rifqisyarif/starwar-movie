import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startwar_movie_app/core/events/app_events.dart';
import 'package:startwar_movie_app/domain/entities/reminder.dart';
import 'package:startwar_movie_app/domain/repositories/movie_repository.dart';
import 'package:startwar_movie_app/domain/repositories/reminder_repository.dart';
import 'package:startwar_movie_app/presentation/movie_list/bloc/movie_event.dart';
import 'package:startwar_movie_app/presentation/movie_list/bloc/movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository movieRepository;
  final ReminderRepository reminderRepository;
  final EventBus eventBus;

  final Set<String> _reminderMovieIds = <String>{};
  late final StreamSubscription<RemindersChanged> _reminderSubscription;

  @override
  void onTransition(Transition<MovieEvent, MovieState> transition) {
    super.onTransition(transition);
    print('Transition: ${transition.event} -> ${transition.nextState}');
  }

  @override
  Future<void> close() {
    _reminderSubscription.cancel();
    return super.close();
  }

  MovieBloc({
    required this.movieRepository,
    required this.reminderRepository,
    required this.eventBus,
  }) : super(MovieInitialState()) {
    on<InitMovieEvent>((event, emit) {
      emit(MovieInitialState());
    });

    on<LoadMovieEvent>(_onLoadMovies);
    on<RefreshMovieRemindersEvent>(_onRefreshMovieReminders);

    _reminderSubscription = eventBus.on<RemindersChanged>().listen((event) {
      add(RefreshMovieRemindersEvent(event.reminders));
    });
  }

  Future<void> _onLoadMovies(
    LoadMovieEvent event,
    Emitter<MovieState> emit,
  ) async {
    emit(MovieLoadingState());

    try {
      final films = await movieRepository.getMovies();

      var reminders = const <Reminder>[];
      try {
        reminders = await reminderRepository.getReminders();
      } catch (error) {
        // Reminder badges are optional; never block the movie list for them.
        debugPrint('Failed to load reminder badges: $error');
      }

      _setReminderMovieIds(reminders);

      emit(
        MovieLoadedState(
          films,
          reminderMovieIds: Set.unmodifiable(_reminderMovieIds),
        ),
      );
    } catch (e) {
      emit(MovieErrorState(e.toString()));
    }
  }

  void _onRefreshMovieReminders(
    RefreshMovieRemindersEvent event,
    Emitter<MovieState> emit,
  ) {
    _setReminderMovieIds(event.reminders);

    final currentState = state;
    if (currentState is MovieLoadedState) {
      emit(
        MovieLoadedState(
          currentState.films,
          reminderMovieIds: Set.unmodifiable(_reminderMovieIds),
        ),
      );
    }
  }

  void _setReminderMovieIds(List<Reminder> reminders) {
    _reminderMovieIds
      ..clear()
      ..addAll(
        reminders
            .map((reminder) => reminder.movieId)
            .where((movieId) => movieId.isNotEmpty),
      );
  }
}
