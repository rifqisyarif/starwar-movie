import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startwar_movie_app/presentation/movie_list/bloc/movie_bloc.dart';
import 'package:startwar_movie_app/presentation/movie_list/bloc/movie_event.dart';
import 'package:startwar_movie_app/presentation/movie_list/pages/movie_list_view.dart';
import 'package:startwar_movie_app/presentation/reminder/pages/reminder_page.dart';

class MovieListPage extends StatelessWidget {
  const MovieListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Star Wars Movies'),
        actionsPadding: EdgeInsets.symmetric(horizontal: 16.0),
        actions: [IconButton(icon: Icon(Icons.notifications),onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ReminderPage()));
        },)],
      ),
      body: BlocProvider(
        create: (context) =>
            MovieBloc(RepositoryProvider.of(context))..add(LoadMovieEvent()),
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<MovieBloc>().add(LoadMovieEvent());
          },
          child: MovieListView(),
        ),
      ),
    );
  }
}
