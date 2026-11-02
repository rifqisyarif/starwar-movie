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
import 'package:startwar_movie_app/presentation/theme/app_theme.dart';
import 'package:startwar_movie_app/presentation/widgets/glass_icon_button.dart';

class CinemaPage extends StatelessWidget {
  const CinemaPage({super.key, required this.filmDetail});

  final MovieDetailModel filmDetail;

  @override
  Widget build(BuildContext context) {
    return StarWarsTheme(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          toolbarHeight: 64,
          leadingWidth: 64,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: GlassIconButton(
              icon: Icons.arrow_back_rounded,
              tooltip: 'Back',
              onPressed: () => Navigator.maybePop(context),
            ),
          ),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CINEMAS NEARBY',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.4,
                  color: AppColors.goldBright,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                filmDetail.title ?? 'Now showing',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        body: MultiBlocProvider(
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
              create: (context) => ReminderBloc(
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
