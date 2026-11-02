class RouteModel {
  final double distance;
  final double duration;
  final List<List<double>> coordinates;

  RouteModel({
    required this.distance,
    required this.duration,
    required this.coordinates,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    final geometry = json['geometry'];

    return RouteModel(
      distance: (json['distance'] as num).toDouble(),
      duration: (json['duration'] as num).toDouble(),
      coordinates: (geometry['coordinates'] as List)
          .map<List<double>>(
            (coordinate) => [
              (coordinate[0] as num).toDouble(),
              (coordinate[1] as num).toDouble(),
            ],
          )
          .toList(),
    );
  }
}