import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Movie {
  final String title;
  final String year;
  final String poster;
  Movie({this.title, this.year, this.poster});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'],
      year: json['Year'],
      poster: json['Poster'],
    );
  }
  static Future<List<Movie>> fetchMovie(String title) async {
    final response =
        await http.get('https://www.omdbapi.com/?s=$title&apikey=d2c50466');

    if (response.statusCode == 200) {
      List<Movie> moviesList = [];
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> rawmovies = jsonDecode(response.body);
      List<dynamic> movies = rawmovies["Search"];
      if (movies != null) {
        movies.forEach((movie) {
          moviesList.add(Movie(
              title: movie['Title'],
              year: movie['Year'],
              poster: movie['Poster']));
        });
      }

      return moviesList;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load movies');
    }
  }
}
