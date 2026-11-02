import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startwar_movie_app/domain/repositories/movie_repository.dart';
import 'package:startwar_movie_app/presentation/movie_detail/bloc/movie_detail_event.dart';
import 'package:startwar_movie_app/presentation/movie_list/bloc/movie_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieState> {
  final MovieRepository filmRepository;
  @override
  void onTransition(Transition<MovieDetailEvent, MovieState> transition) {
    super.onTransition(transition);
    print('Transition: ${transition.event} -> ${transition.nextState}');
  }

  MovieDetailBloc(this.filmRepository) : super(MovieInitialState()) {
    on<LoadMovieDetailEvent>((event, emit) async {
      emit(MovieDetailLoadingState());
      try {
        final filmDetail = await filmRepository.getMovieDetail(event.url);
        emit(MovieDetailLoadedState(filmDetail));
      } catch (e) {
        emit(MovieDetailErrorState(e.toString()));
      }
    });
  }
}
