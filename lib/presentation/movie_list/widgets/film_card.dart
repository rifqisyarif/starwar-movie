import 'package:flutter/material.dart';
import 'package:startwar_movie_app/data/models/movie_list_model.dart';
import 'package:startwar_movie_app/presentation/movie_detail/pages/movie_detail_page.dart';
import 'package:startwar_movie_app/presentation/theme/app_theme.dart';
import 'package:startwar_movie_app/presentation/widgets/roman_numeral.dart';

class FilmCard extends StatelessWidget {
  const FilmCard({super.key, required this.film});

  final MovieData film;

  @override
  Widget build(BuildContext context) {
    final roman = romanNumeral(film.episodeId);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(url: film.url ?? ''),
            ),
          );
        },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.surface, AppColors.backgroundAlt],
            ),
            border: Border.all(
              color: AppColors.gold.withValues(alpha: 0.14),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.32),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                _EpisodePoster(roman: roman),
                const SizedBox(width: 14),
                Expanded(
                  child: SizedBox(
                    height: 104,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          roman.isEmpty ? 'STAR WARS' : 'EPISODE $roman',
                          style: AppTheme.label.copyWith(
                            fontSize: 9,
                            letterSpacing: 1.8,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          film.title ?? 'Untitled',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.title.copyWith(fontSize: 16.5),
                        ),
                        const SizedBox(height: 8),
                        _MetaRow(
                          icon: Icons.movie_creation_outlined,
                          text: film.director ?? 'Unknown director',
                        ),
                        const SizedBox(height: 4),
                        _MetaRow(
                          icon: Icons.calendar_today_rounded,
                          text: film.releaseDate ?? 'Unknown release date',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.gold.withValues(alpha: 0.75),
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EpisodePoster extends StatelessWidget {
  const _EpisodePoster({required this.roman});

  final String roman;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 78,
      height: 104,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2C3552), Color(0xFF11182A)],
        ),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.22)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 8,
            left: 9,
            child: Icon(
              Icons.star_rounded,
              size: 13,
              color: AppColors.gold.withValues(alpha: 0.85),
            ),
          ),
          Positioned(
            bottom: -12,
            right: -8,
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.gold.withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              roman.isEmpty ? '?' : roman,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                color: AppColors.goldBright,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 9,
            child: Text(
              'EPISODE',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 7.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.8,
                color: AppColors.textSecondary.withValues(alpha: 0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: AppColors.textMuted),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              height: 1.2,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
