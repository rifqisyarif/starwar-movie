import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startwar_movie_app/data/models/movie_detail_model.dart';
import 'package:startwar_movie_app/presentation/cinema/pages/cinema_page.dart';
import 'package:startwar_movie_app/presentation/movie_detail/bloc/movie_detail_bloc.dart';
import 'package:startwar_movie_app/presentation/movie_detail/bloc/movie_detail_event.dart';
import 'package:startwar_movie_app/presentation/movie_list/bloc/movie_state.dart';
import 'package:startwar_movie_app/presentation/theme/app_theme.dart';
import 'package:startwar_movie_app/presentation/widgets/app_state_views.dart';
import 'package:startwar_movie_app/presentation/widgets/roman_numeral.dart';
import 'package:startwar_movie_app/presentation/widgets/section_label.dart';
import 'package:startwar_movie_app/presentation/widgets/starfield_background.dart';

class MovieDetailView extends StatelessWidget {
  const MovieDetailView({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieDetailBloc, MovieState>(
      builder: (context, state) {
        if (state is MovieDetailLoadingState || state is MovieInitialState) {
          return const StarfieldBackground(
            child: AppLoadingView(message: 'Opening the archive...'),
          );
        }

        if (state is MovieDetailErrorState) {
          return StarfieldBackground(
            child: AppErrorView(
              message: state.message,
              onRetry: () => context.read<MovieDetailBloc>().add(
                LoadMovieDetailEvent(url),
              ),
            ),
          );
        }

        if (state is MovieDetailLoadedState) {
          final filmDetail = state.filmDetail;
          final topInset = MediaQuery.paddingOf(context).top + 64 + 12;

          return StarfieldBackground(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(20, topInset, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailHero(filmDetail: filmDetail),
                  const SizedBox(height: 28),
                  const SectionLabel('Production'),
                  const SizedBox(height: 14),
                  _MetaGrid(filmDetail: filmDetail),
                  const SizedBox(height: 28),
                  const SectionLabel('Opening crawl'),
                  const SizedBox(height: 14),
                  _OpeningCrawlPanel(
                    text: filmDetail.openingCrawl ?? 'No crawl available.',
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CinemaPage(filmDetail: filmDetail),
                          ),
                        );
                      },
                      icon: const Icon(Icons.local_movies_rounded, size: 20),
                      label: const Text('Find Cinemas Nearby'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      'Plan your next trip to the movies',
                      style: AppTheme.body.copyWith(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _DetailHero extends StatelessWidget {
  const _DetailHero({required this.filmDetail});

  final MovieDetailModel filmDetail;

  @override
  Widget build(BuildContext context) {
    final roman = romanNumeral(filmDetail.episodeId);

    return Stack(
      children: [
        Positioned(
          top: -34,
          right: -10,
          child: IgnorePointer(
            child: Text(
              roman.isEmpty ? '?' : roman,
              style: TextStyle(
                fontSize: 128,
                height: 1,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: AppColors.gold.withValues(alpha: 0.07),
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              roman.isEmpty ? 'STAR WARS' : 'EPISODE $roman',
              style: AppTheme.label.copyWith(letterSpacing: 3),
            ),
            const SizedBox(height: 12),
            Text(
              filmDetail.title ?? 'Untitled',
              style: AppTheme.display.copyWith(fontSize: 34),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoPill(
                  icon: Icons.calendar_today_rounded,
                  label: filmDetail.releaseDate ?? 'Unknown release',
                ),
                const _InfoPill(
                  icon: Icons.star_rounded,
                  label: 'Skywalker Saga',
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.gold),
          const SizedBox(width: 7),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaGrid extends StatelessWidget {
  const _MetaGrid({required this.filmDetail});

  final MovieDetailModel filmDetail;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth = (constraints.maxWidth - 12) / 2;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: tileWidth,
              child: _MetaTile(
                icon: Icons.videocam_outlined,
                label: 'DIRECTOR',
                value: filmDetail.director ?? '-',
              ),
            ),
            SizedBox(
              width: tileWidth,
              child: _MetaTile(
                icon: Icons.groups_2_outlined,
                label: 'PRODUCER',
                value: filmDetail.producer ?? '-',
              ),
            ),
            SizedBox(
              width: tileWidth,
              child: _MetaTile(
                icon: Icons.event_outlined,
                label: 'RELEASE',
                value: filmDetail.releaseDate ?? '-',
              ),
            ),
            SizedBox(
              width: tileWidth,
              child: _MetaTile(
                icon: Icons.movie_outlined,
                label: 'EPISODE',
                value: romanNumeral(filmDetail.episodeId).isEmpty
                    ? '-'
                    : romanNumeral(filmDetail.episodeId),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MetaTile extends StatelessWidget {
  const _MetaTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.gold),
              const SizedBox(width: 7),
              Text(
                label,
                style: AppTheme.label.copyWith(
                  fontSize: 8.5,
                  letterSpacing: 1.6,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              height: 1.3,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _OpeningCrawlPanel extends StatelessWidget {
  const _OpeningCrawlPanel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceHigh.withValues(alpha: 0.95),
            AppColors.surface.withValues(alpha: 0.95),
          ],
        ),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_stories_rounded,
                size: 15,
                color: AppColors.gold,
              ),
              const SizedBox(width: 8),
              Text(
                'A GALAXY FAR, FAR AWAY',
                style: AppTheme.label.copyWith(fontSize: 8.5, letterSpacing: 1.8),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            text.trim(),
            style: TextStyle(
              fontSize: 14.5,
              height: 1.75,
              fontStyle: FontStyle.italic,
              color: AppColors.goldBright.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}
