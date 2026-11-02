import 'package:geolocator/geolocator.dart';
import 'package:startwar_movie_app/data/datasource/location_datasource.dart';
import 'package:startwar_movie_app/domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource dataSource;
    LocationRepositoryImpl(this.dataSource);

  @override
  Future<Position> getCurrentLocation() async {
    try {
      final location = await dataSource.getCurrentPosition();
      return location;
    } catch (e) {
      throw Exception('Failed to fetch current location: $e');
    } 
  }
}