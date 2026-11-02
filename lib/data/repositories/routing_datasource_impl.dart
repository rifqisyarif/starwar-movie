import 'package:startwar_movie_app/data/datasource/routing_datasource.dart';

import '../../domain/entities/route.dart';
import '../../domain/repositories/routing_repository.dart';

class RoutingRepositoryImpl implements RoutingRepository {
  final RoutingDataSource remoteDataSource;

  RoutingRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Route> getRoute({
    required double originLat,
    required double originLng,
    required double destinationLat,
    required double destinationLng,
  }) async {
    final result = await remoteDataSource.getRoute(
      originLat: originLat,
      originLng: originLng,
      destinationLat: destinationLat,
      destinationLng: destinationLng,
    );

    return Route(
      distance: result.distance,
      duration: result.duration,
      points: result.coordinates.map((coordinate) {
        return RoutePoint(
          longitude: coordinate[0],
          latitude: coordinate[1],
        );
      }).toList(),
    );
  }
}