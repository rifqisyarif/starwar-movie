import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startwar_movie_app/presentation/movie_list/bloc/movie_bloc.dart';
import 'package:startwar_movie_app/presentation/movie_list/bloc/movie_event.dart';
import 'package:startwar_movie_app/presentation/movie_list/pages/movie_list_view.dart';
import 'package:startwar_movie_app/presentation/reminder/pages/reminder_page.dart';
import 'package:startwar_movie_app/presentation/theme/app_theme.dart';
import 'package:startwar_movie_app/presentation/widgets/glass_icon_button.dart';

class MovieListPage extends StatelessWidget {
  const MovieListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StarWarsTheme(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 74,
          titleSpacing: 20,
          flexibleSpace: const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.background, Color(0xFF101A33)],
              ),
            ),
          ),
          title: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'STAR WARS',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 5,
                  color: AppColors.goldBright,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'SKYWALKER SAGA',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 3,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          actions: [
            GlassIconButton(
              icon: Icons.notifications_none_rounded,
              tooltip: 'Reminders',
              foregroundColor: AppColors.gold,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReminderPage(),
                  ),
                );
              },
            ),
            const SizedBox(width: 20),
          ],
        ),
        body: BlocProvider(
          create: (context) =>
              MovieBloc(RepositoryProvider.of(context))
                ..add(const LoadMovieEvent()),
          child: const MovieListView(),
        ),
      ),
    );
  }
}
