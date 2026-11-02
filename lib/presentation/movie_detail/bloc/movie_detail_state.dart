import 'package:startwar_movie_app/data/models/movie_detail_model.dart';

sealed class MovieDetailState {}

class FilmDetailLoadingState extends MovieDetailState {}

class FilmDetailLoadedState extends MovieDetailState {
  final MovieDetailModel filmDetail;

  FilmDetailLoadedState(this.filmDetail);
}

class FilmDetailErrorState extends MovieDetailState {
  final String message;

  FilmDetailErrorState(this.message);
}
