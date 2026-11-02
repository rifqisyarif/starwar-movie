import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startwar_movie_app/domain/repositories/location_repository.dart';
import 'package:startwar_movie_app/presentation/cinema/bloc/location/location_event.dart';
import 'package:startwar_movie_app/presentation/cinema/bloc/location/location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository locationRepository;

  @override
  void onTransition(Transition<LocationEvent, LocationState> transition) {
    super.onTransition(transition);
    print('Transition: ${transition.event} -> ${transition.nextState}');
  }

  LocationBloc(this.locationRepository) : super(LocationInitial()) {
    on<LocationRequestingEvent>((event, emit) async {
      emit(LocationLoading());

      try {
        final location = await locationRepository.getCurrentLocation();

        emit(LocationLoaded(location: location));
      } catch (e) {
        emit(LocationError(message: e.toString()));
      }
    });
  }
}
