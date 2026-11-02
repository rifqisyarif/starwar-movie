import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/route_model.dart';

abstract class RoutingDataSource {
  Future<RouteModel> getRoute({
    required double originLat,
    required double originLng,
    required double destinationLat,
    required double destinationLng,
  });
}

class RoutingDataSourceImpl implements RoutingDataSource {

  RoutingDataSourceImpl();

  @override
  Future<RouteModel> getRoute({
    required double originLat,
    required double originLng,
    required double destinationLat,
    required double destinationLng,
  }) async {
    final url = Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/'
      '$originLng,$originLat;$destinationLng,$destinationLat'
      '?overview=full&geometries=geojson',
    );

    final response = await http.get(url);

    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch route');
    }

    final json = jsonDecode(response.body);

    if (json['code'] != 'Ok' ||
        (json['routes'] as List).isEmpty) {
      throw Exception('No route found');
    }

    return RouteModel.fromJson(json['routes'][0]);
  }
}