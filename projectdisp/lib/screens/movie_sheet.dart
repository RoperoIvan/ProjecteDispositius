import 'package:flutter/material.dart';
import '../model/movie.dart';

class MovieSheet extends StatelessWidget {
  final Movie movie;
  MovieSheet(this.movie);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
    );
  }
}
