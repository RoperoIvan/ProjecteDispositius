import 'package:flutter/material.dart';
import '../model/movie.dart';
import 'movie_sheet.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen();

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _controller;
  Future<List<Movie>> futureMovies;
  Widget _searchTitle = Text("Search");
  Icon _searchIcon = Icon(Icons.search);
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
          title: _searchTitle,
          leading: IconButton(
            icon: _searchIcon,
            onPressed: () {
              _onSearchPressed();
            },
          )),
      body: FutureBuilder(
        future: futureMovies,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Card(
                  child: InkWell(
                    child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Image.network(snapshot.data[index].poster),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(snapshot.data[index].title),
                              Text(snapshot.data[index].year),
                            ],
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      Movie movie;
                      Future<Movie> pickedMovie =
                          Movie.fetchMovie(snapshot.data[index].title);
                      pickedMovie.then((value) {
                        movie = value;
                        if (movie != null) {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                builder: (context) => MovieSheet(movie),
                              ))
                              .then((value) {});
                        } else {
                          return CircularProgressIndicator();
                        }
                      });
                    },
                  ),
                );
              },
            );
          } else {
            return Card();
          }
        },
      ),
    );
  }

  _onSearchPressed() {
    setState(() {
      if (_searchIcon.icon == Icons.search) {
        _searchIcon = Icon(Icons.close);
        _searchTitle = TextField(
          autofocus: true,
          cursorColor: Colors.black,
          style: TextStyle(fontSize: 24),
          decoration: InputDecoration(labelText: 'Search...'),
          controller: _controller,
          onSubmitted: (value) {
            setState(() {
              futureMovies = Movie.fetchMovies(value);
            });
          },
        );
      } else {
        _searchTitle = Text("Search");
        _searchIcon = Icon(Icons.search);
      }
    });
  }
}