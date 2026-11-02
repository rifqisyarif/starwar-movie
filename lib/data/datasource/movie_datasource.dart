import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:startwar_movie_app/data/models/movie_detail_model.dart';
import 'package:startwar_movie_app/data/models/movie_list_model.dart';

abstract class MovieDataSource {
  Future<List<MovieData>> getMovies();
  Future<MovieDetailModel> getMovieDetail(String url);
}

class MovieDataSourceImpl implements MovieDataSource {
  @override
  Future<List<MovieData>> getMovies() async {
    final response = await http.get(Uri.parse('https://swapi.dev/api/films/'));
  
    if (response.statusCode == 200) {
      final data = MovieListModel.fromJson(jsonDecode(response.body));
      return data.results ?? [];
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Future<MovieDetailModel> getMovieDetail(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return MovieDetailModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load movie detail');
    }
  }
}
