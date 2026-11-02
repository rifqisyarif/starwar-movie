class Route {
  final double distance;
  final double duration;
  final List<RoutePoint> points;

  Route({
    required this.distance,
    required this.duration,
    required this.points,
  });
}

class RoutePoint {
  final double latitude;
  final double longitude;

  RoutePoint({
    required this.latitude,
    required this.longitude,
  });
}