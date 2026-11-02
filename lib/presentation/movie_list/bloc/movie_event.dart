import 'package:startwar_movie_app/data/models/movie_detail_model.dart';

sealed class MovieEvent {
  const MovieEvent();
}

class InitMovieEvent extends MovieEvent {
  const InitMovieEvent();
}

class LoadMovieEvent extends MovieEvent {
  const LoadMovieEvent();
}

class RefreshMovieReminderEvent extends MovieEvent {
  final String cinemaId;
  final DateTime scheduledAt;
  final MovieDetailModel filmDetail;

  const RefreshMovieReminderEvent({
    required this.cinemaId,
    required this.scheduledAt,
    required this.filmDetail,
  });
}
