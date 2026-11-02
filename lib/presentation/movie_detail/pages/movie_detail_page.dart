import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startwar_movie_app/presentation/movie_detail/bloc/movie_detail_bloc.dart';
import 'package:startwar_movie_app/presentation/movie_detail/bloc/movie_detail_event.dart';
import 'package:startwar_movie_app/presentation/movie_detail/pages/movie_detail_view.dart';

class DetailPage extends StatelessWidget {
  final String url;
  const DetailPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Screen')),
      body: BlocProvider(
        create: (context) =>
            MovieDetailBloc(RepositoryProvider.of(context))
              ..add(LoadMovieDetailEvent(url)),
        child: MovieDetailView(),
      ),
    );
  }
}
