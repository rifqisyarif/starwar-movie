import 'package:flutter/material.dart';
import 'package:startwar_movie_app/data/models/movie_list_model.dart';
import 'package:startwar_movie_app/presentation/movie_detail/pages/movie_detail_page.dart';

class FilmCard extends StatelessWidget {
  final MovieData film;
  const FilmCard({super.key, required this.film});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8.0),
      ), 
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailPage(url: film.url ?? '')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4.0,
            children: [
              Text(
                film.title ?? '-',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('Director: ${film.director ?? '-'}'),
              const SizedBox(height: 4.0),
              Text('Release Date: ${film.releaseDate ?? '-'}'),
            ],
          ),
        ),
      ),
    );
  }
}
