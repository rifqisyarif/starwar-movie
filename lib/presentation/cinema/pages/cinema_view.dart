import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:startwar_movie_app/data/models/movie_detail_model.dart';
import 'package:startwar_movie_app/domain/entities/cinema.dart';
import 'package:startwar_movie_app/domain/entities/reminder.dart';
import 'package:startwar_movie_app/presentation/cinema/bloc/cinema/cinema_bloc.dart';
import 'package:startwar_movie_app/presentation/cinema/bloc/cinema/cinema_event.dart';
import 'package:startwar_movie_app/presentation/cinema/bloc/cinema/cinema_state.dart';
import 'package:startwar_movie_app/presentation/cinema/bloc/location/location_bloc.dart';
import 'package:startwar_movie_app/presentation/cinema/bloc/location/location_event.dart';
import 'package:startwar_movie_app/presentation/cinema/bloc/location/location_state.dart';
import 'package:startwar_movie_app/presentation/cinema/bloc/route/route_bloc.dart';
import 'package:startwar_movie_app/presentation/cinema/bloc/route/route_event.dart';
import 'package:startwar_movie_app/presentation/cinema/bloc/route/route_state.dart';
import 'package:startwar_movie_app/presentation/cinema/widgets/cinema_info_panel.dart';
import 'package:startwar_movie_app/presentation/cinema/widgets/location_status_card.dart';
import 'package:startwar_movie_app/presentation/cinema/widgets/reminder_form.dart';
import 'package:startwar_movie_app/presentation/reminder/bloc/reminder_bloc.dart';
import 'package:startwar_movie_app/presentation/reminder/bloc/reminder_event.dart';
import 'package:startwar_movie_app/presentation/theme/app_theme.dart';
import 'package:startwar_movie_app/presentation/widgets/app_snackbar.dart';
import 'package:startwar_movie_app/presentation/widgets/app_state_views.dart';
import 'package:startwar_movie_app/presentation/widgets/starfield_background.dart';

class CinemaView extends StatefulWidget {
  const CinemaView({super.key, required this.filmDetail});

  final MovieDetailModel filmDetail;

  @override
  State<CinemaView> createState() => _CinemaViewState();
}

class _CinemaViewState extends State<CinemaView> {
  static const double _routeBoundsPadding = 72;

  Cinema? selectedCinema;
  GoogleMapController? _mapController;
  LatLngBounds? _pendingRouteBounds;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, locationState) {
        return BlocBuilder<CinemaBloc, CinemaState>(
          builder: (context, state) {
            if (state is CinemaLoadingState || state is CinemaInitialState) {
              return const StarfieldBackground(
                child: AppLoadingView(message: 'Locating cinemas nearby...'),
              );
            }

            if (state is CinemaErrorState) {
              return StarfieldBackground(
                child: AppErrorView(
                  message: state.message,
                  onRetry: () =>
                      context.read<CinemaBloc>().add(const LoadCinemasEvent()),
                ),
              );
            }

            if (state is CinemaLoadedState) {
              return _buildMap(context, locationState, state.cinemas);
            }

            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  Widget _buildMap(
    BuildContext context,
    LocationState locationState,
    List<Cinema> cinemas,
  ) {
    final markers = <Marker>{};

    for (final cinema in cinemas) {
      final isSelected = selectedCinema?.id == cinema.id;
      markers.add(
        Marker(
          markerId: MarkerId(cinema.id),
          position: LatLng(cinema.latitude, cinema.longitude),
          infoWindow: InfoWindow(title: cinema.name),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            isSelected
                ? BitmapDescriptor.hueOrange
                : BitmapDescriptor.hueYellow,
          ),
          onTap: () {
            if (selectedCinema?.id != cinema.id) {
              context.read<RouteBloc>().add(ClearRouteEvent());
            }
            setState(() => selectedCinema = cinema);
            _mapController?.animateCamera(
              CameraUpdate.newLatLng(LatLng(cinema.latitude, cinema.longitude)),
            );
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

    final topInset = MediaQuery.paddingOf(context).top + 64 + 12;

    return BlocBuilder<RouteBloc, RouteState>(
      builder: (context, routeState) {
        return BlocListener<RouteBloc, RouteState>(
          listenWhen: (previous, current) =>
              current is RouteLoaded &&
              (previous is! RouteLoaded || previous.route != current.route),
          listener: (context, state) => _fitCameraToRoute(state),
          child: Stack(
            fit: StackFit.expand,
            children: [
              BlocListener<LocationBloc, LocationState>(
                listener: (context, state) {
                  if (state is LocationLoaded) {
                    _mapController?.animateCamera(
                      CameraUpdate.newLatLng(
                        LatLng(
                          state.location.latitude,
                          state.location.longitude,
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
                        : const LatLng(-6.1754, 106.8272),
                    zoom: 12,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;

                    final pendingBounds = _pendingRouteBounds;
                    if (pendingBounds != null) {
                      _pendingRouteBounds = null;
                      controller.animateCamera(
                        CameraUpdate.newLatLngBounds(
                          pendingBounds,
                          _routeBoundsPadding,
                        ),
                      );
                    }
                  },
                  markers: markers,
                  polylines: {
                    if (routeState is RouteLoaded &&
                        routeState.route.points.isNotEmpty)
                      Polyline(
                        polylineId: const PolylineId('cinema_route'),
                        points: routeState.route.points
                            .map(
                              (point) =>
                                  LatLng(point.latitude, point.longitude),
                            )
                            .toList(),
                        color: AppColors.gold,
                        width: 5,
                      ),
                  },
                  compassEnabled: false,
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  padding: EdgeInsets.only(
                    top: topInset + 80,
                    bottom: selectedCinema == null ? 110 : 260,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: topInset + 24,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.background.withValues(alpha: 0.92),
                          AppColors.background.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: topInset - 46,
                left: 16,
                right: 16,
                child: LocationStatusCard(
                  state: locationState,
                  onRetry: () => context.read<LocationBloc>().add(
                    const LocationRequestingEvent(),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 0,
                child: SafeArea(
                  top: false,
                  minimum: const EdgeInsets.only(bottom: 16),
                  child: CinemaInfoPanel(
                    cinema: selectedCinema,
                    routeState: routeState,
                    hasLocation: locationState is LocationLoaded,
                    isLocating:
                        locationState is LocationLoading ||
                        locationState is LocationInitial,
                    onCheckRoute: () {
                      final cinema = selectedCinema;
                      if (cinema == null || locationState is! LocationLoaded) {
                        return;
                      }

                      context.read<RouteBloc>().add(
                        GetRouteEvent(
                          originLat: locationState.location.latitude,
                          originLng: locationState.location.longitude,
                          destinationLat: cinema.latitude,
                          destinationLng: cinema.longitude,
                        ),
                      );
                    },
                    onClearRoute: () {
                      context.read<RouteBloc>().add(ClearRouteEvent());
                      setState(() => selectedCinema = null);
                    },
                    onSetReminder: () {
                      final cinema = selectedCinema;
                      if (cinema != null) {
                        _showReminderDialog(context, cinema);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _fitCameraToRoute(RouteState state) {
    if (state is! RouteLoaded) {
      return;
    }

    final points = state.route.points;
    if (points.isEmpty) {
      return;
    }

    var minLat = points.first.latitude;
    var maxLat = points.first.latitude;
    var minLng = points.first.longitude;
    var maxLng = points.first.longitude;

    for (final point in points.skip(1)) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    // Expand degenerate bounds so the camera does not zoom in too far.
    const minSpan = 0.002;
    if (maxLat - minLat < minSpan) {
      final centerLat = (minLat + maxLat) / 2;
      minLat = centerLat - minSpan / 2;
      maxLat = centerLat + minSpan / 2;
    }
    if (maxLng - minLng < minSpan) {
      final centerLng = (minLng + maxLng) / 2;
      minLng = centerLng - minSpan / 2;
      maxLng = centerLng + minSpan / 2;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    final controller = _mapController;
    if (controller == null) {
      _pendingRouteBounds = bounds;
      return;
    }

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, _routeBoundsPadding),
    );
  }

  void _showReminderDialog(BuildContext context, Cinema cinema) {
    final reminderBloc = context.read<ReminderBloc>();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Set a reminder'),
          content: ReminderForm(
            movieTitle: widget.filmDetail.title ?? 'Unknown movie',
            cinemaName: cinema.name,
            onSubmit: (reminderTime) {
              final reminder = Reminder(
                id: DateTime.now().toIso8601String(),
                movieId: widget.filmDetail.episodeId?.toString() ?? '',
                cinemaId: cinema.id,
                scheduledAt: reminderTime,
                filmDetail: widget.filmDetail,
              );

              reminderBloc.add(ScheduleReminderEvent(reminder));
              Navigator.of(dialogContext).pop();

              showAppSnackBar(
                context,
                message: 'Reminder set for ${cinema.name}',
                icon: Icons.notifications_active_rounded,
                actionLabel: 'OK',
              );
            },
          ),
        );
      },
    );
  }
}
