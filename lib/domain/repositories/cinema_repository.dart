import 'package:startwar_movie_app/domain/entities/cinema.dart';

abstract class CinemaRepository {
  Future<List<Cinema>> getCinemas();
} 