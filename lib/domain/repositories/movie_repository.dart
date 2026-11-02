import 'package:startwar_movie_app/data/models/movie_detail_model.dart';
import 'package:startwar_movie_app/data/models/movie_list_model.dart';

abstract class MovieRepository {
  Future<List<MovieData>> getMovies();
  Future<MovieDetailModel> getMovieDetail(String url);
}