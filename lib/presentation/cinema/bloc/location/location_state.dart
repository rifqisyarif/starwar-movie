import 'package:geolocator/geolocator.dart';

sealed class LocationState {
  const LocationState();
}

class LocationInitial extends LocationState {
  const LocationInitial();
}

class LocationLoading extends LocationState {
  const LocationLoading();
}

class LocationLoaded extends LocationState {
  final Position location;
  const LocationLoaded({required this.location});
}

class LocationError extends LocationState {
  final String message;
  const LocationError({required this.message});
}