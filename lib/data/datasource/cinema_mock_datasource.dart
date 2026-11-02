import 'package:startwar_movie_app/domain/entities/cinema.dart';

abstract class CinemaMockDataSource {
  Future<List<Cinema>> getCinemas();
}

class CinemaMockDataSourceImpl implements CinemaMockDataSource {
  @override
  Future<List<Cinema>> getCinemas() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return const [
      Cinema(
        id: '1',
        name: 'Cinema A',
        latitude: -6.1754,
        longitude: 106.8272,
      ),
      Cinema(
        id: '2',
        name: 'Cinema B',
        latitude: -6.2000,
        longitude: 106.8167,
      ),
      Cinema(
        id: '3',
        name: 'Cinema C',
        latitude: -6.2297,
        longitude: 106.8295,
      ),
      Cinema(
        id: '4',
        name: 'Cinema D',
        latitude: -6.1900,
        longitude: 106.8230,
      ),
      Cinema(
        id: '5',
        name: 'Cinema E',
        latitude: -6.2146,
        longitude: 106.8451,
      ),
    ];
  }
}