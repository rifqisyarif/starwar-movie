import 'package:startwar_movie_app/data/models/movie_detail_model.dart';

class Reminder {
  final String id;
  final String movieId;
  final String cinemaId;
  final DateTime scheduledAt;
  final MovieDetailModel filmDetail;

  const Reminder({
    required this.id,
    required this.movieId,
    required this.cinemaId,
    required this.scheduledAt,
    required this.filmDetail,
  });
}