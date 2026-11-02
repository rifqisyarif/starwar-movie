import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/repositories/routing_repository.dart';
import 'route_event.dart';
import 'route_state.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  final RoutingRepository repository;



  @override
  void onTransition(Transition<RouteEvent, RouteState> transition) {
    super.onTransition(transition);
    print('Transition: ${transition.event} -> ${transition.nextState}');
  }

  RouteBloc(this.repository) : super(RouteInitial()) {
    on<GetRouteEvent>(_onGetRoute);
    on<ClearRouteEvent>(_onClearRoute);
  }

  Future<void> _onGetRoute(
    GetRouteEvent event,
    Emitter<RouteState> emit,
  ) async {
    emit(RouteLoading());

    try {
      final route = await repository.getRoute(
        originLat: event.originLat,
        originLng: event.originLng,
        destinationLat: event.destinationLat,
        destinationLng: event.destinationLng,
      );

      emit(RouteLoaded(route));
    } catch (e) {
      emit(RouteError(e.toString()));
    }
  }

  void _onClearRoute(ClearRouteEvent event, Emitter<RouteState> emit) {
    emit(RouteInitial());}
}
