import 'package:flutter/material.dart';
import '../model/movie.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen();

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _controller;
  Future<List<Movie>> futureMovies;

  @override
  void initState() {
    _controller = TextEditingController();
    //futureMovies = Movie.fetchMovie("");
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
        leading: TextField(
          controller: _controller,
          onSubmitted: (value) {
            setState(() {
              futureMovies = Movie.fetchMovie(value);
            });
          },
        ),
      ),
      body: FutureBuilder(
        future: futureMovies,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Container(
                      child: Image.network(snapshot.data[index].poster)),
                );
              },
            );
          } else {
            return ListTile();
          }
        },
      ),
    );
  }
}
