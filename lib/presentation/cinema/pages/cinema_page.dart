import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startwar_movie_app/data/models/movie_detail_model.dart';
import 'package:startwar_movie_app/presentation/cinema/bloc/cinema/cinema_bloc.dart';
import 'package:startwar_movie_app/presentation/cinema/bloc/cinema/cinema_event.dart';
import 'package:startwar_movie_app/presentation/cinema/bloc/location/location_bloc.dart';
import 'package:startwar_movie_app/presentation/cinema/bloc/location/location_event.dart';
import 'package:startwar_movie_app/presentation/cinema/bloc/route/route_bloc.dart';
import 'package:startwar_movie_app/presentation/cinema/pages/cinema_view.dart';
import 'package:startwar_movie_app/presentation/reminder/bloc/reminder_bloc.dart';

class CinemaPage extends StatelessWidget {
  final MovieDetailModel filmDetail;
  const CinemaPage({super.key, required this.filmDetail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cinemas Nearby')),

      body: SafeArea(
        bottom: true,

        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  CinemaBloc(RepositoryProvider.of(context))
                    ..add(const LoadCinemasEvent()),
            ),
            BlocProvider(
              lazy: false,
              create: (context) =>
                  LocationBloc(RepositoryProvider.of(context))
                    ..add(const LocationRequestingEvent()),
            ),
            BlocProvider(
              create: (context) => RouteBloc(RepositoryProvider.of(context)),
            ),
            BlocProvider(
              create: (context)=>ReminderBloc(
                repository: RepositoryProvider.of(context),
                eventBus: RepositoryProvider.of(context),
              ),
            ),
          ],
          child: CinemaView(filmDetail: filmDetail),
        ),
      ),
    );
  }
}
