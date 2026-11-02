import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startwar_movie_app/presentation/movie_detail/bloc/movie_detail_bloc.dart';
import 'package:startwar_movie_app/presentation/movie_detail/bloc/movie_detail_event.dart';
import 'package:startwar_movie_app/presentation/movie_detail/pages/movie_detail_view.dart';
import 'package:startwar_movie_app/presentation/theme/app_theme.dart';
import 'package:startwar_movie_app/presentation/widgets/glass_icon_button.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.url});

  final String url;

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
          title: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MOVIE DETAIL',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.4,
                  color: AppColors.goldBright,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'ARCHIVE ENTRY',
                style: TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.2,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        body: BlocProvider(
          create: (context) =>
              MovieDetailBloc(RepositoryProvider.of(context))
                ..add(LoadMovieDetailEvent(url)),
          child: MovieDetailView(url: url),
        ),
      ),
    );
  }
}
