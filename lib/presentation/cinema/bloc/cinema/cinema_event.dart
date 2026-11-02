import 'package:startwar_movie_app/data/models/cinema_list_model.dart';

sealed class CinemaEvent {
  const CinemaEvent();
}

class InitCinemaEvent extends CinemaEvent {
  const InitCinemaEvent();
} 


class LoadCinemasEvent extends CinemaEvent {
  const LoadCinemasEvent();
}

class ErrorCinemasEvent extends CinemaEvent {
  final String message;
  const ErrorCinemasEvent(this.message);
}

class CinemasLoadedEvent extends CinemaEvent {
  final List<CinemaData> cinemas;
  const CinemasLoadedEvent(this.cinemas);
}

