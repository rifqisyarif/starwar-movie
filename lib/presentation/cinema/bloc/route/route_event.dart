abstract class RouteEvent {}

class GetRouteEvent extends RouteEvent {
  final double originLat;
  final double originLng;

  final double destinationLat;
  final double destinationLng;

  GetRouteEvent({
    required this.originLat,
    required this.originLng,
    required this.destinationLat,
    required this.destinationLng,
  });
}

class ClearRouteEvent extends RouteEvent {}
