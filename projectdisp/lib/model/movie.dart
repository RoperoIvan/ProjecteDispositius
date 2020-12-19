import 'dart:async';
import 'dart:convert';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class Movie {
  final String title;
  final String year;
  final String poster;
  final String baseRate;
  final String id;
  final String plot;
  final String genre;
  final String director;
  final String writers;
  final String actors;
  final String runtime;
  Movie(
      {this.title,
      this.year,
      this.poster,
      this.baseRate,
      this.id,
      this.plot,
      this.genre,
      this.director,
      this.writers,
      this.actors,
      this.runtime});

  static Future<Movie> fetchMovie(String title) async {
    //This is to get full info of an specific movie
    final response =
        await http.get('https://www.omdbapi.com/?i=$title&apikey=d2c50466');
    if (response.statusCode == 200) {
      Movie pickedMovie;
      Map<String, dynamic> rawmovies = jsonDecode(response.body);
      if (rawmovies != null) {
        pickedMovie = Movie(
            title: rawmovies['Title'],
            year: rawmovies['Year'],
            poster: rawmovies['Poster'],
            baseRate: rawmovies['imdbRating'],
            id: rawmovies['imdbID'],
            plot: rawmovies['Plot'],
            genre: rawmovies['Genre'],
            director: rawmovies['Director'],
            writers: rawmovies['Writer'],
            actors: rawmovies['Actors'],
            runtime: rawmovies['Runtime']);
      }
      return pickedMovie;
    } else {
      throw Exception('Failed to load movies');
    }
  }

  static String cropStrings(String title, int desiredLenght,
      {bool threeDots = false}) {
    if (title.length > desiredLenght) {
      if (threeDots) return title.substring(0, desiredLenght - 1) + '...';

      return title.substring(0, desiredLenght - 1);
    }

    return title;
  }

  static List<String> getGenre(String genre) {
    List<String> genres = [];
    if (genre.indexOf(',') == -1) {
      genres.add(genre);
      return genres;
    }
    String firstGenre = genre.substring(0, genre.indexOf(','));
    genres.add(firstGenre);
    genres.add(genre.substring(firstGenre.length + 2, genre.length));

    return genres;
  }

  static Future<List<Movie>> fetchMovies(String title) async {
    //This one is to get all the movies that have the title searched but does not give all the info
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
              id: movie['imdbID'],
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
