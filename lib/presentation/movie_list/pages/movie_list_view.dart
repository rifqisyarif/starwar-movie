import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startwar_movie_app/presentation/movie_list/bloc/movie_bloc.dart';
import 'package:startwar_movie_app/presentation/movie_list/bloc/movie_state.dart';
import 'package:startwar_movie_app/presentation/movie_list/widgets/film_card.dart';

class MovieListView extends StatelessWidget {
  const MovieListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieBloc, MovieState>(
      builder: (context, state) {
        print(
          'Current state: $state',
        ); // Debugging line to print the current state
        if (state is MovieLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MovieErrorState) {
          return Center(child: Text(state.message));
        } else if (state is MovieLoadedState) {
          final films = state.films;
          return ListView.builder(
            itemCount: films.length,
            itemBuilder: (context, index) {
              final film = films[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilmCard(film: film),
              );
            },
          );
        }
        return Center(
          child: Text('Unknown state'),
        ); // Return an empty widget for other states
      },
    );
  }
}
