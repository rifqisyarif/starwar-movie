import 'package:startwar_movie_app/data/models/cinema_list_model.dart';

abstract class CinemaMockDataSource {
  Future<List<CinemaData>> getCinemas();
}

class CinemaMockDataSourceImpl implements CinemaMockDataSource {
  @override
  Future<List<CinemaData>> getCinemas() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return const [
      CinemaData(
        id: '1',
        name: 'Cinema A',
        latitude: -6.1754,
        longitude: 106.8272,
      ),
      CinemaData(
        id: '2',
        name: 'Cinema B',
        latitude: -6.2000,
        longitude: 106.8167,
      ),
      CinemaData(
        id: '3',
        name: 'Cinema C',
        latitude: -6.2297,
        longitude: 106.8295,
      ),
      CinemaData(
        id: '4',
        name: 'Cinema D',
        latitude: -6.1900,
        longitude: 106.8230,
      ),
      CinemaData(
        id: '5',
        name: 'Cinema E',
        latitude: -6.2146,
        longitude: 106.8451,
      ),
    ];
  }
}