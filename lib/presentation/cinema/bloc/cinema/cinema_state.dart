import 'package:startwar_movie_app/domain/entities/cinema.dart';

sealed class CinemaState {
  const CinemaState();
}

class CinemaInitialState extends CinemaState {
  const CinemaInitialState();
}

class CinemaLoadingState extends CinemaState {
  const CinemaLoadingState();
}

class CinemaLoadedState extends CinemaState {
  final List<Cinema> cinemas;
  const CinemaLoadedState(this.cinemas);
}

class CinemaErrorState extends CinemaState {
  final String message;
  const CinemaErrorState(this.message);
}