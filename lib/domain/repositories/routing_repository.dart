import '../entities/route.dart';

abstract class RoutingRepository {
  Future<Route> getRoute({
    required double originLat,
    required double originLng,
    required double destinationLat,
    required double destinationLng,
  });
}