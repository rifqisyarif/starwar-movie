import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startwar_movie_app/core/events/app_event_bus.dart';
import 'package:startwar_movie_app/core/events/app_events.dart';
import 'package:startwar_movie_app/domain/repositories/movie_repository.dart';
import 'package:startwar_movie_app/presentation/movie_list/bloc/movie_event.dart';
import 'package:startwar_movie_app/presentation/movie_list/bloc/movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository movieRepository;
  late final StreamSubscription<ReminderScheduled> _reminderSubscription;
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

  MovieBloc(this.movieRepository) : super(MovieInitialState()) {
    on<InitMovieEvent>((event, emit) {
      emit(MovieInitialState());
    });

    on<LoadMovieEvent>((event, emit) async {
      emit(MovieLoadingState());
      try {
        final films = await movieRepository.getMovies();
        emit(MovieLoadedState(films));
      } catch (e) {
        emit(MovieErrorState(e.toString()));
      }
    });
    _reminderSubscription = appEventBus.on<ReminderScheduled>().listen((event) {
      add(
        RefreshMovieReminderEvent(
          cinemaId: event.cinemaId,
          scheduledAt: event.scheduledAt,
          filmDetail: event.filmDetail,
        ),
      );
    });
  }
}
