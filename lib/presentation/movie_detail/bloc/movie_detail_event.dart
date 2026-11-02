abstract class MovieDetailEvent {
  const MovieDetailEvent();
}

class LoadMovieDetailEvent extends MovieDetailEvent {
  final String url;

  const LoadMovieDetailEvent(this.url);
}