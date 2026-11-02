import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startwar_movie_app/presentation/cinema/pages/cinema_page.dart';
import 'package:startwar_movie_app/presentation/movie_detail/bloc/movie_detail_bloc.dart';
import 'package:startwar_movie_app/presentation/movie_list/bloc/movie_state.dart';

class MovieDetailView extends StatelessWidget {
  const MovieDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieDetailBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieDetailLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is MovieDetailErrorState) {
              return Center(
                child: Text(state.message),
              );
            } else if (state is MovieDetailLoadedState) {
              final filmDetail = state.filmDetail;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Title: ${filmDetail.title ?? '-'}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8.0),
                    Text('Director: ${filmDetail.director ?? '-'}'),
                    const SizedBox(height: 4.0),
                    Text('Producer: ${filmDetail.producer ?? '-'}'),
                    const SizedBox(height: 4.0),
                    Text('Release Date: ${filmDetail.releaseDate ?? '-'}'),
                    const SizedBox(height: 4.0),
                    Text('Opening Crawl:\n${filmDetail.openingCrawl ?? '-'}'),
                    const SizedBox(height: 8,),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  CinemaPage(filmDetail: filmDetail)));
                      },
                      child: const Text('Find Cinemas Nearby'),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink(); // Return an empty widget for other states
          },
        );
  }
}