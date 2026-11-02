import 'package:startwar_movie_app/data/datasource/movie_datasource.dart';
import 'package:startwar_movie_app/data/models/movie_detail_model.dart';
import 'package:startwar_movie_app/data/models/movie_list_model.dart';
import 'package:startwar_movie_app/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieDataSource remoteDataSource;

  MovieRepositoryImpl( this.remoteDataSource);

  @override
  Future<List<MovieData>> getMovies() async {
    try {
      final films = await remoteDataSource.getMovies();
      return films;
    } catch (e) {
      throw Exception('Failed to fetch films: $e');
    }
  }

  @override
  Future<MovieDetailModel> getMovieDetail(String url) async {
    try {
      final filmDetail = await remoteDataSource.getMovieDetail(url);
      return filmDetail;
    } catch (e) {
      throw Exception('Failed to fetch film detail: $e'); 
    }}
}