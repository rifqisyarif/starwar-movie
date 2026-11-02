import 'package:startwar_movie_app/data/models/cinema_list_model.dart';

abstract class CinemaRepository {
  Future<List<CinemaData>> getCinemas();
} 