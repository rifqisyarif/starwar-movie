import 'package:startwar_movie_app/data/models/movie_detail_model.dart';
import 'package:startwar_movie_app/data/models/movie_list_model.dart';

sealed class MovieState {}

class MovieInitialState extends MovieState {}

class MovieLoadingState extends MovieState {}

class MovieLoadedState extends MovieState {
  final List<MovieData> films;

  MovieLoadedState(this.films);
}

class MovieErrorState extends MovieState {
  final String message;

  MovieErrorState(this.message);
}

class MovieDetailLoadingState extends MovieState {}

class MovieDetailLoadedState extends MovieState {
  final MovieDetailModel filmDetail;

  MovieDetailLoadedState(this.filmDetail);
}

class MovieDetailErrorState extends MovieState {
  final String message;

  MovieDetailErrorState(this.message);
}

class MovieReminderUpdatedState extends MovieState {
  final String cinemaId;
  final DateTime scheduledAt;
  final MovieDetailModel filmDetail;

  MovieReminderUpdatedState(this.cinemaId, this.scheduledAt, this.filmDetail);
}
