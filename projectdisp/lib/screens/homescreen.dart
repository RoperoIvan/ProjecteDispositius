//import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:projectdisp/custom_colors.dart';
import '../model/movie.dart';
import 'movie_sheet.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen();
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _controller;
  List<Future<Movie>> futureMovies;
  List<Future<Movie>> topRatedMovies;
  SliverGridDelegate delegate;
  @override
  void initState() {
    _controller = TextEditingController();
    futureMovies = [];
    //topRatedMovies = [];
    futureMovies = getCarrouselMovies();
    topRatedMovies = _getTopMovies();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    futureMovies.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                ),
                items: [0, 1, 2, 3, 4].map((i) {
                  if (futureMovies.isNotEmpty) {
                    return FutureBuilder(
                      future: futureMovies[i],
                      builder: (context, s) {
                        if (s.data != null) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 1.0),
                            decoration: BoxDecoration(color: customAmber),
                            child: AspectRatio(
                              aspectRatio: 8 / 5,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.fitWidth,
                                    alignment: FractionalOffset.topCenter,
                                    image: Image.network(s.data.poster).image,
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else
                          return CircularProgressIndicator();
                      },
                    );
                  } else
                    return CircularProgressIndicator();
                }).toList(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              decoration: BoxDecoration(
                color: customViolet,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Top Rated",
                  style: TextStyle(
                      color: customAmber,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 9 / 12, crossAxisCount: 3),
                  itemCount: topRatedMovies.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                        future: topRatedMovies[index],
                        builder: (c, s) {
                          if (topRatedMovies.isEmpty) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            if (s.data != null) {
                              return Card(
                                child: InkWell(
                                  child: Stack(children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: Image.network(s.data.poster)
                                                .image),
                                      ),
                                    ),
                                    Container(
                                        height: 40,
                                        color: Color.fromRGBO(0, 0, 0, 0.5),
                                        child: Row(
                                          children: [
                                            Icon(Icons.star,
                                                color: customAmber),
                                            Text(
                                              (index + 1).toString(),
                                              style: TextStyle(
                                                color: customAmber,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            )
                                          ],
                                        )),
                                  ]),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MovieSheet(s.data)));
                                  },
                                ),
                              );
                            } else
                              return Center(child: CircularProgressIndicator());
                          }
                        });
                  }),
            ),
          ],
        ),
      ),
    );
  }

  List<Future<Movie>> getCarrouselMovies() {
    List<Future<Movie>> carMovies = [];
    carMovies.add(Movie.fetchMovieByTitle('The Godfather'));
    carMovies.add(Movie.fetchMovieByTitle('Pokemon'));
    carMovies.add(Movie.fetchMovieByTitle('Spider-Man'));
    carMovies.add(Movie.fetchMovieByTitle('Toy Story'));
    carMovies.add(Movie.fetchMovieByTitle('The Simpsons'));
    return carMovies;
  }

  List<Future<Movie>> _getTopMovies() {
    List<Future<Movie>> fMovies = [];
    Map<String, num> aux = Map<String, num>();
    Stream<QuerySnapshot> snapshot =
        FirebaseFirestore.instance.collection('films').snapshots();

    snapshot.forEach((element) {
      List<DocumentSnapshot> docs = element.docs;
      if (docs.length == 0) return null;
      docs.forEach(
        (element) {
          setState(() {
            if (element.data()['Average'] != null) {
              aux[element.id] = num.parse(element.data()['Average']);
            }
          });
        },
      );
      while (aux != null) {
        String mostAverageMovie = aux.keys.first;
        num beforeAverage = aux[mostAverageMovie];
        aux.forEach((key, value) {
          if (value > beforeAverage) mostAverageMovie = key;
        });
        setState(() {
          aux.remove(mostAverageMovie);
          if (fMovies.length < 9)
            fMovies.add(Movie.fetchMovie(mostAverageMovie));
          else
            return fMovies;
        });
      }
    });
    return fMovies;
  }
}
