import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../custom_colors.dart';
import '../model/movie.dart';
import 'review_screen.dart';
import 'rate_screen.dart';
import '../widgets/review_item.dart';

class MovieSheet extends StatefulWidget {
  final Movie movie;

  MovieSheet(this.movie);

  @override
  _MovieSheetState createState() => _MovieSheetState();
}

class _MovieSheetState extends State<MovieSheet> {
  num _rate;
  bool _favourite;
  Icon _favIcon;
  List<Container> _genres;
  Future<List<dynamic>> reviews;
  List<dynamic> actualRev;

  void initState() {
    _rate = 0.0;
    _favourite = false;
    _favIcon = Icon(Icons.favorite_border);
    _genres = _getAllGenres(widget.movie.genre);
    actualRev = [];
    reviews = _getReviews(widget.movie.id);
    reviews.then((value) {
      setState(() {
        actualRev = value;
      });
    });
    //reviews = _getReviews(widget.movie.id);
    saveFavouriteInfoInFireBase();
    super.initState();
  }

  @override
  void dispose() {
    _genres.clear();
    actualRev.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundPurple,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(children: [
                  AspectRatio(
                    aspectRatio: 8 / 5,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          alignment: FractionalOffset.topCenter,
                          image: Image.network(widget.movie.poster).image,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.close, color: customAmber),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ]),
                Container(
                  height: 80,
                  decoration: BoxDecoration(color: customViolet[700]),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Text(
                                  //Title
                                  Movie.cropStrings(widget.movie.title, 14,
                                      threeDots: true),
                                  style: TextStyle(
                                      color: customAmber, fontSize: 35),
                                ),
                                Text(
                                  //Year and duration
                                  widget.movie.year +
                                      ' · ' +
                                      widget.movie.runtime,
                                  style: TextStyle(color: customAmber),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: _favIcon,
                              color: customAmber,
                              iconSize: 40,
                              onPressed: () {
                                User currentUser =
                                    FirebaseAuth.instance.currentUser;
                                var favourite = {'Favourite': !_favourite};
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(currentUser.email)
                                    .collection('films')
                                    .doc(widget.movie.id)
                                    .update(favourite);
                                setState(() {
                                  _favourite = !_favourite;
                                  if (_favourite == true)
                                    _favIcon = Icon(Icons.favorite);
                                  else
                                    _favIcon = Icon(Icons.favorite_border);
                                });
                              },
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: _AverageRate(widget: widget),
                            ),
                            Expanded(
                              flex: 2,
                              child: IconButton(
                                  //Rate Icon
                                  icon: Icon(
                                    Icons.star_border,
                                    size: 40,
                                    color: customAmber,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          RateScreen(widget.movie),
                                    ))
                                        .then((value) {
                                      if (value != null) {
                                        _rate = value;
                                        _saveRateInfoIntoFireBase(
                                            value.toString());
                                      }
                                    });
                                  }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 170,
                            width: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                alignment: FractionalOffset.topCenter,
                                image: Image.network(
                                  widget.movie.poster,
                                ).image,
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: _genres,
                                  ),
                                  SizedBox(
                                    width: 80,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                  height: 120,
                                  width: 250,
                                  decoration: BoxDecoration(
                                    color: customViolet[700],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        MovieTeamText(
                                          position: 'Director:',
                                          name: Movie.cropStrings(
                                              widget.movie.director, 18,
                                              threeDots: true),
                                        ),
                                        MovieTeamText(
                                          position: 'Writers:',
                                          name: Movie.cropStrings(
                                              widget.movie.writers, 18,
                                              threeDots: true),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Actors:',
                                              style: TextStyle(
                                                color: customAmber,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Flexible(
                                              child: Text(
                                                Movie.cropStrings(
                                                    widget.movie.actors, 52,
                                                    threeDots: true),
                                                style: TextStyle(
                                                  color: customAmber,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        height: 150,
                        padding: EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: customViolet[700],
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              //I know this is ugly Att: Ivan
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Storyline:',
                                  style: TextStyle(
                                      color: customAmber,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              widget.movie.plot,
                              style:
                                  TextStyle(color: customAmber, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          child: Text("Add review"),
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) =>
                                        ReviewScreen(movie: widget.movie)))
                                .then((value) {
                              if (value != null) {
                                setState(() {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser.email)
                                      .collection('films')
                                      .doc(widget.movie.id)
                                      .get()
                                      .then((value) =>
                                          _rate = value.data()['Rate']);

                                  var newReviewItem = {
                                    'Title': value.title,
                                    'Description': value.body,
                                    'Username': FirebaseAuth
                                        .instance.currentUser.displayName,
                                    'Id': FirebaseAuth.instance.currentUser.uid,
                                    'Email':
                                        FirebaseAuth.instance.currentUser.email,
                                    'Photo': FirebaseAuth
                                        .instance.currentUser.photoURL,
                                    'Rate': value.rate,
                                  };
                                  actualRev.add(newReviewItem);
                                  addNewReviewToDataBase(newReviewItem);
                                });
                              }
                            });
                          },
                        ),
                      ),
                      Container(
                        height: 200.0,
                        child: ListView.separated(
                          itemCount: actualRev.length,
                          itemBuilder: (context, index) {
                            if (actualRev.length == 0) {
                              return CircularProgressIndicator();
                            }
                            return Container(
                              decoration: BoxDecoration(
                                  color: customViolet[700],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16))),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          height: 130,
                                          width: 220,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                flex: 1,
                                                child: Text(
                                                  actualRev[index]['Title'],
                                                  style: TextStyle(
                                                    color: customAmber,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                flex: 1,
                                                child: Text(
                                                  actualRev[index]
                                                      ['Description'],
                                                  style: TextStyle(
                                                    color: customAmber,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                              height: 70,
                                              width: 70,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  fit: BoxFit.fitWidth,
                                                  alignment:
                                                      FractionalOffset.center,
                                                  image: Image.network(
                                                          actualRev[index]
                                                              ['Photo'])
                                                      .image,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              actualRev[index]['Username'],
                                              style: TextStyle(
                                                color: customAmber,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              actualRev[index]['Rate']
                                                  .toString(),
                                              style: TextStyle(
                                                color: customAmber,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              SizedBox(
                            height: 10,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _saveRateInfoIntoFireBase(String a) {
    User currentUser = FirebaseAuth.instance.currentUser;

    var newRate = {'Rate': a};
    //save into user
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email)
        .collection('films')
        .doc(widget.movie.id)
        .get()
        .then((value) {
      if (value.exists) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.email)
            .collection('films')
            .doc(widget.movie.id)
            .update(newRate);
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.email)
            .collection('films')
            .doc(widget.movie.id)
            .set(newRate);
      }
    });

    var filmRate = {
      currentUser.uid: a,
    };
    //save into films
    FirebaseFirestore.instance
        .collection('films')
        .doc(widget.movie.id)
        .get()
        .then((value) {
      if (!value.exists) {
        FirebaseFirestore.instance
            .collection('films')
            .doc(widget.movie.id)
            .set(filmRate);
        setAverage();
      } else {
        FirebaseFirestore.instance
            .collection('films')
            .doc(widget.movie.id)
            .get()
            .then((value) {
          if (value.exists) {
            FirebaseFirestore.instance
                .collection('films')
                .doc(widget.movie.id)
                .update(filmRate);
          } else {
            FirebaseFirestore.instance
                .collection('films')
                .doc(widget.movie.id)
                .set(filmRate);
          }
          setAverage();
        });
      }
    });
  }

  void setAverage() {
    num grade = 0.0;
    FirebaseFirestore.instance
        .collection('films')
        .doc(widget.movie.id)
        .get()
        .then((value) {
      if (value.exists) {
        Map<String, dynamic> map = value.data();
        map.forEach((key, val) {
          if (key != 'Average') {
            num x = num.parse(val);
            grade += x;
          }
        });
        if (map.length > 1)
          grade = grade / (map.length - 1);
        else
          grade = grade / map.length;

        var average = {'Average': grade.toStringAsFixed(1)};

        FirebaseFirestore.instance
            .collection('films')
            .doc(widget.movie.id)
            .update(average);
      }
    });
  }

  Future<List<dynamic>> _getReviews(String movieId) async {
    //User currentUser = FirebaseAuth.instance.currentUser;
    List<Map<String, dynamic>> newReviews = [];
    await FirebaseFirestore.instance
        .collection('films')
        .doc(widget.movie.id)
        .collection('reviews')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in value.docs) {
          if (doc.data() != null && doc.data().isNotEmpty) {
            for (Map<String, dynamic> review in doc.data()['review']) {
              newReviews.add(review);
            }
          }
        }
      }
    });
    return newReviews;
  }

  void saveFavouriteInfoInFireBase() {
    User currentUser = FirebaseAuth.instance.currentUser;
    var favourite = {'Favourite': false};
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email)
        .collection('films')
        .doc(widget.movie.id)
        .get()
        .then((value) {
      if (!value.exists) {
        //Check if document of the movie does not exists
        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.email)
            .collection('films')
            .doc(widget.movie.id)
            .set(favourite);
      } else {
        if (value.data()['Favourite'] == null) {
          //Check if fav field exists
          FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.email)
              .collection('films')
              .doc(widget.movie.id)
              .update(favourite);
        } else {
          FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.email)
              .collection('films')
              .doc(widget.movie.id)
              .get()
              .then((value) {
            setState(() {
              _favourite = value.data()['Favourite'];
              if (_favourite == true)
                _favIcon = Icon(Icons.favorite);
              else
                _favIcon = Icon(Icons.favorite_border);
            });
          });
        }
      }
    });
  }

  void addNewReviewToDataBase(Map<String, dynamic> newReviewItem) async {
    User currentUser = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email)
        .collection('films')
        .doc(widget.movie.id)
        .get()
        .then((value) {
      if (!value.exists) {
        //Check if document of the movie does not exists
        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.email)
            .collection('films')
            .doc(widget.movie.id)
            .set({
          'Reviews': FieldValue.arrayUnion([
            [newReviewItem]
          ])
        });
      } else {
        if (value.data()['Reviews'] != null) {
          //Check if fav field exists
          FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.email)
              .collection('films')
              .doc(widget.movie.id)
              .update({
            'Reviews': FieldValue.arrayUnion([newReviewItem])
          });
        } else {
          FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.email)
              .collection('films')
              .doc(widget.movie.id)
              .update({
            'Reviews': FieldValue.arrayUnion([newReviewItem])
          });
        }
      }
    });

    //Films server side
    await FirebaseFirestore.instance
        .collection('films')
        .doc(widget.movie.id)
        .collection('reviews')
        .get()
        .then((value) {
      bool isThere = false;
      for (QueryDocumentSnapshot doc in value.docs) {
        if (doc.id == currentUser.uid) {
          isThere = true;
          FirebaseFirestore.instance
              .collection('films')
              .doc(widget.movie.id)
              .collection('reviews')
              .doc(currentUser.uid)
              .update({
            'review': FieldValue.arrayUnion([newReviewItem])
          });
        }
      }
      if (!isThere) {
        FirebaseFirestore.instance
            .collection('films')
            .doc(widget.movie.id)
            .collection('reviews')
            .doc(currentUser.uid)
            .set({
          'review': FieldValue.arrayUnion([newReviewItem])
        });
      }
    });
  }
}

List<Container> _getAllGenres(String genre) {
  List<String> genres;
  genres = Movie.getGenre(genre);
  List<Container> genreWidgets;
  genreWidgets = [];
  genres.forEach((g) {
    genreWidgets.add(Container(
      width: 80,
      height: 25,
      decoration: BoxDecoration(
        color: customAmber,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Center(
        child: Text(g, //Need to set all genres
            style: TextStyle(
              color: backgroundPurple,
              fontWeight: FontWeight.bold,
            )),
      ),
    ));
  });
  return genreWidgets;
}

class MovieTeamText extends StatelessWidget {
  const MovieTeamText({
    this.position,
    this.name,
  });

  final String position;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          position,
          style: TextStyle(
            color: customAmber,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(
          width: 15,
        ),
        Text(
          name,
          style: TextStyle(
            color: customAmber,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class _AverageRate extends StatelessWidget {
  const _AverageRate({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final MovieSheet widget;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('films').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Construir un widget en función de los datos
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<DocumentSnapshot> docs = snapshot.data.docs;
          if (docs.isEmpty)
            return Text('0',
                style: TextStyle(
                  color: customAmber,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ));
          num i = 0;
          bool passRates = false;
          docs.forEach((element) {
            if (element.id == widget.movie.id) passRates = true;

            if (!passRates) ++i;
          });
          if (i == docs.length) {
            return Text(
              "0",
              style: TextStyle(
                color: customAmber,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            );
          } else {
            if (docs[i].data()['Average'] != null)
              return Text(
                docs[i].data()['Average'],
                style: TextStyle(
                  color: customAmber,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              );
            else
              return Text('0',
                  style: TextStyle(
                    color: customAmber,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ));
          }
        });
  }
}
