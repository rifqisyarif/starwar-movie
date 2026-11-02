import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startwar_movie_app/presentation/movie_list/bloc/movie_bloc.dart';
import 'package:startwar_movie_app/presentation/movie_list/bloc/movie_event.dart';
import 'package:startwar_movie_app/presentation/movie_list/bloc/movie_state.dart';
import 'package:startwar_movie_app/presentation/movie_list/widgets/film_card.dart';
import 'package:startwar_movie_app/presentation/movie_list/widgets/saga_header.dart';
import 'package:startwar_movie_app/presentation/theme/app_theme.dart';
import 'package:startwar_movie_app/presentation/widgets/app_state_views.dart';
import 'package:startwar_movie_app/presentation/widgets/starfield_background.dart';

class MovieListView extends StatelessWidget {
  const MovieListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieBloc, MovieState>(
      builder: (context, state) {
        if (state is MovieLoadingState || state is MovieInitialState) {
          return const StarfieldBackground(
            child: AppLoadingView(message: 'Loading the saga...'),
          );
        }

        if (state is MovieErrorState) {
          return StarfieldBackground(
            child: AppErrorView(
              message: state.message,
              onRetry: () =>
                  context.read<MovieBloc>().add(const LoadMovieEvent()),
            ),
          );
        }

        if (state is MovieLoadedState) {
          final films = state.films;
          final reminderMovieIds = state.reminderMovieIds;

          if (films.isEmpty) {
            return StarfieldBackground(
              child: AppEmptyView(
                icon: Icons.movie_filter_outlined,
                title: 'No films found',
                message: 'The archives returned no episodes.',
                action: OutlinedButton.icon(
                  onPressed: () =>
                      context.read<MovieBloc>().add(const LoadMovieEvent()),
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Reload'),
                ),
              ),
            );
          }

          return StarfieldBackground(
            child: RefreshIndicator(
              color: AppColors.gold,
              backgroundColor: AppColors.surfaceHigh,
              onRefresh: () async {
                final bloc = context.read<MovieBloc>();
                final done = bloc.stream.firstWhere(
                  (state) =>
                      state is MovieLoadedState || state is MovieErrorState,
                );
                bloc.add(const LoadMovieEvent());
                await done.timeout(
                  const Duration(seconds: 10),
                  onTimeout: () => bloc.state,
                );
              },
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 36),
                itemCount: films.length + 1,
                separatorBuilder: (context, index) =>
                    SizedBox(height: index == 0 ? 24 : 14),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return SagaHeader(filmCount: films.length);
                  }

                  final film = films[index - 1];

                  return FilmCard(
                    film: film,
                    hasReminder: reminderMovieIds.contains(
                      film.episodeId?.toString(),
                    ),
                  );
                },
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
