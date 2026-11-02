import 'package:startwar_movie_app/data/models/movie_detail_model.dart';

class ReminderScheduled {
  final String cinemaId;
  final DateTime scheduledAt;
  final MovieDetailModel filmDetail;

  ReminderScheduled({
    required this.cinemaId,
    required this.scheduledAt,
    required this.filmDetail,
  });
}

class ReminderCancelled {
  final String cinemaId;

  ReminderCancelled({
    required this.cinemaId,
  });
}