import '../../../../domain/entities/route.dart';

sealed class RouteState {}

class RouteInitial extends RouteState {}

class RouteLoading extends RouteState {}

class RouteLoaded extends RouteState {
  final Route route;

  RouteLoaded(this.route);
}

class RouteError extends RouteState {
  final String message;

  RouteError(this.message);
}

class RouteCleared extends RouteState {}