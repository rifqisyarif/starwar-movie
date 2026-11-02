import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:startwar_movie_app/core/events/app_event_bus.dart';
import 'package:startwar_movie_app/core/events/app_events.dart';
import 'package:startwar_movie_app/data/models/cinema_list_model.dart';
import 'package:startwar_movie_app/data/models/movie_detail_model.dart';
import 'package:startwar_movie_app/domain/entities/reminder.dart';
import 'package:startwar_movie_app/presentation/cinema/bloc/cinema/cinema_bloc.dart';
import 'package:startwar_movie_app/presentation/cinema/bloc/cinema/cinema_state.dart';
import 'package:startwar_movie_app/presentation/cinema/bloc/location/location_bloc.dart';
import 'package:startwar_movie_app/presentation/cinema/bloc/location/location_state.dart';
import 'package:startwar_movie_app/presentation/cinema/bloc/route/route_bloc.dart';
import 'package:startwar_movie_app/presentation/cinema/bloc/route/route_event.dart';
import 'package:startwar_movie_app/presentation/cinema/bloc/route/route_state.dart';
import 'package:startwar_movie_app/presentation/cinema/widgets/reminder_form.dart';
import 'package:startwar_movie_app/presentation/reminder/bloc/reminder_bloc.dart';
import 'package:startwar_movie_app/presentation/reminder/bloc/reminder_event.dart';

class CinemaView extends StatefulWidget {
  final MovieDetailModel filmDetail;

  const CinemaView({super.key, required this.filmDetail});

  @override
  State<CinemaView> createState() => _CinemaViewState();
}

class _CinemaViewState extends State<CinemaView> {
  CinemaData? selectedCinema;
  GoogleMapController? _mapController;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, locationState) {
        return BlocBuilder<CinemaBloc, CinemaState>(
          builder: (context, state) {
            if (state is CinemaLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CinemaErrorState) {
              return Center(child: Text(state.message));
            } else if (state is CinemaLoadedState) {
              final cinemas = state.cinemas;
              final markers = <Marker>{};

              for (final cinema in cinemas) {
                markers.add(
                  Marker(
                    markerId: MarkerId(cinema.id),
                    position: LatLng(cinema.latitude, cinema.longitude),
                    infoWindow: InfoWindow(title: cinema.name),
                    onTap: () {
                      setState(() {
                        selectedCinema = cinema;
                      });
                    },
                  ),
                );
              }

              if (locationState is LocationLoaded) {
                markers.add(
                  Marker(
                    markerId: const MarkerId('current_location'),
                    position: LatLng(
                      locationState.location.latitude,
                      locationState.location.longitude,
                    ),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure,
                    ),
                  ),
                );
              }

              return BlocBuilder<RouteBloc, RouteState>(
                builder: (context, routeState) {
                  return Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Expanded(
                        child: BlocListener<LocationBloc, LocationState>(
                          listener: (context, locationState) {
                            if (locationState is LocationLoaded) {
                              _mapController?.animateCamera(
                                CameraUpdate.newLatLng(
                                  LatLng(
                                    locationState.location.latitude,
                                    locationState.location.longitude,
                                  ),
                                ),
                              );
                            }
                          },
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: locationState is LocationLoaded
                                  ? LatLng(
                                      locationState.location.latitude,
                                      locationState.location.longitude,
                                    )
                                  : LatLng(
                                      -6.1754,
                                      106.8272,
                                    ), // Jakarta coordinates
                              zoom: 12,
                            ),
                            onMapCreated: (controller) {
                              _mapController = controller;
                            },
                            markers: markers.toSet(),
                            polylines: {
                              if (routeState is RouteLoaded &&
                                  routeState.route.points.isNotEmpty)
                                Polyline(
                                  polylineId: const PolylineId('cinema_route'),
                                  points: routeState.route.points
                                      .map(
                                        (point) => LatLng(
                                          point.latitude,
                                          point.longitude,
                                        ),
                                      )
                                      .toList(),
                                  color: Colors.blue,
                                  width: 5,
                                ),
                            },
                          ),
                        ),
                      ),
                      if (selectedCinema != null)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (routeState is RouteLoaded)
                                  ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Reminder Set'),
                                            content: ReminderForm(
                                              movieTitle: selectedCinema!.name,
                                              onSubmit: (reminderTime) {
                                                final reminder = Reminder(
                                                  id: DateTime.now()
                                                      .toIso8601String(),
                                                  movieId: widget
                                                      .filmDetail
                                                      .episodeId
                                                      .toString(),
                                                  cinemaId: selectedCinema!.id,
                                                  scheduledAt: reminderTime,
                                                  filmDetail: widget.filmDetail,
                                                );

                                                context
                                                    .read<ReminderBloc>()
                                                    .add(
                                                      ScheduleReminderEvent(
                                                        reminder,
                                                      ),
                                                    );
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Reminder set for ${selectedCinema!.name} at ${reminderTime.toLocal()}',
                                                    ),
                                                    duration: Duration(
                                                      seconds: 3,
                                                    ),
                                                    action: SnackBarAction(
                                                      label: 'OK',
                                                      onPressed: () {
                                                        // Aksi ketika tombol ditekan
                                                      },
                                                    ),
                                                  ),
                                                );
                                                // Handle the reminder time submission
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: const Text('Set Reminder'),
                                  ),

                                const SizedBox(height: 8),
                                if (routeState is RouteLoaded)
                                  ElevatedButton(
                                    onPressed: () {
                                      context.read<RouteBloc>().add(
                                        ClearRouteEvent(),
                                      );
                                      setState(() {
                                        selectedCinema = null;
                                      });
                                    },
                                    child: const Text('Clear Route'),
                                  ),

                                const SizedBox(height: 8),
                                // Check Route Button
                                ElevatedButton(
                                  onPressed: routeState is RouteLoading
                                      ? null
                                      : () {
                                          if (locationState is LocationLoaded) {
                                            context.read<RouteBloc>().add(
                                              GetRouteEvent(
                                                originLat: locationState
                                                    .location
                                                    .latitude,
                                                originLng: locationState
                                                    .location
                                                    .longitude,
                                                destinationLat:
                                                    selectedCinema!.latitude,
                                                destinationLng:
                                                    selectedCinema!.longitude,
                                              ),
                                            );
                                          }
                                        },
                                  child: const Text('Check Route'),
                                ),

                                // Route conditions
                                if (routeState is RouteLoading)
                                  const CircularProgressIndicator(),

                                if (routeState is RouteLoaded) ...[
                                  Text(
                                    'Distance: ${(routeState.route.distance / 1000).toStringAsFixed(2)} km',
                                  ),
                                  Text(
                                    'ETA: ${(routeState.route.duration / 60).ceil()} minutes',
                                  ),
                                ],

                                if (routeState is RouteError)
                                  Text(
                                    routeState.message,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              );
            }
            return const SizedBox.shrink(); // Return an empty widget for other states
          },
        );
      },
    );
  }
}
