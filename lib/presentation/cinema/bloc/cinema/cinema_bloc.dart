import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startwar_movie_app/domain/repositories/cinema_repository.dart';
import 'package:startwar_movie_app/presentation/cinema/bloc/cinema/cinema_event.dart';
import 'package:startwar_movie_app/presentation/cinema/bloc/cinema/cinema_state.dart';

class CinemaBloc extends Bloc<CinemaEvent, CinemaState> {
  final CinemaRepository cinemaRepository;

  @override
  void onTransition(Transition<CinemaEvent, CinemaState> transition) {
    super.onTransition(transition);
    print('Transition: ${transition.event} -> ${transition.nextState}');
  }

  CinemaBloc(this.cinemaRepository) : super(CinemaInitialState()) {
    on<InitCinemaEvent>((event, emit) {
      emit(const CinemaInitialState());
    });

    on<LoadCinemasEvent>((event, emit) async {
      emit(const CinemaLoadingState());
      try {
        final cinemas = await cinemaRepository.getCinemas();
        emit(CinemaLoadedState(cinemas));
      } catch (e) {
        emit(CinemaErrorState(e.toString()));
      }
    });
  }
}
