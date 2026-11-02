import 'package:startwar_movie_app/data/datasource/cinema_mock_datasource.dart';
import 'package:startwar_movie_app/domain/entities/cinema.dart';
import 'package:startwar_movie_app/domain/repositories/cinema_repository.dart';

class CinemaRepositoryImpl implements CinemaRepository {
  final CinemaMockDataSource dataSource;

  CinemaRepositoryImpl({required this.dataSource});

  @override
  Future<List<Cinema>> getCinemas() async {
    return dataSource.getCinemas();
  }
}