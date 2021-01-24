import 'package:flutter/material.dart';
import '../custom_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'homescreen.dart';
import 'editProfileScreen.dart';
import 'search_page.dart';
import '../model/movie.dart';
import '../model/review.dart';
import 'movie_sheet.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  TickerProvider selectedPage;

  TabController _tabController;
  List<Future<Movie>> futureMovies;
  Future<List<Map<String, dynamic>>> futureReviews;
  List<Map<String, dynamic>> reviews;

  final _pageOptions = [
    HomeScreen(),
    SearchScreen(),
    //ProfileScreen(),
  ];

  final List<Tab> myTabs = <Tab>[
    Tab(
        icon: Icon(
      Icons.star_border,
      size: 40,
    )),
    Tab(
        icon: Icon(
      Icons.comment,
      size: 40,
    ))
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _pageOptions.length);
    reviews = [];
    futureMovies = _getFavMovies();
    futureReviews = _getReviews();
    futureReviews.then((value) {
      reviews = value;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    futureMovies.clear();
    reviews.clear();
    super.dispose();
  }

  List<Future<Movie>> _getFavMovies() {
    List<Future<Movie>> fMovies = [];
    Stream<QuerySnapshot> snapshot = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.email)
        .collection('films')
        .snapshots();

    snapshot.forEach((element) {
      List<DocumentSnapshot> docs = element.docs;
      if (docs.length == 0) return null;
      setState(() {
        docs.forEach(
          (element) {
            if (element.data()['Favourite'] == true) {
              fMovies.add(Movie.fetchMovie(element.id));
            }
          },
        );
      });
    });
    return fMovies;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar:
          AppBar(backgroundColor: customAmber, elevation: 0, actions: <Widget>[
        IconButton(
            icon: Icon(
              Icons.more_vert,
              size: 40,
            ),
            color: customViolet,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditProfileScreen(),
              ));
            })
      ]),
      body: Stack(
        children: [
          Expanded(
            child: Container(
              color: customAmber,
            ),
          ),
          //profile info
          Column(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    color: customAmber,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '@' +
                                  FirebaseAuth.instance.currentUser.displayName,
                              style: TextStyle(
                                fontSize: 20,
                                color: customViolet,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            //TODO: Responsive bio
                            Text(
                              'Bio in next release',
                              maxLines: 4,
                              style: TextStyle(
                                fontSize: 14,
                                color: customViolet,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Color(0xffFF006E),
                          child: FirebaseAuth.instance.currentUser.photoURL !=
                                  null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(55),
                                  child: Image.network(
                                    FirebaseAuth.instance.currentUser.photoURL,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xffFF006E),
                                      borderRadius: BorderRadius.circular(50)),
                                  width: 100,
                                  height: 100,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey[800],
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //films, comments
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20),
                        ),
                        color: backgroundPurple,
                      ),
                      child: navBar(context),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: backgroundPurple,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(36.0),
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              ListView.builder(
                                  itemCount: futureMovies.length,
                                  itemBuilder: (context, index) {
                                    return FutureBuilder(
                                        future: futureMovies[index],
                                        builder: (c, s) {
                                          if (futureMovies.isEmpty) {
                                            return Center(
                                                child: Container(
                                                    child: Text(
                                                        'Show favs not avaiable in these release. Thanks for your patience',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white))));
                                          } else {
                                            return Container(
                                              child: s.data == null
                                                  ? Container()
                                                  : Card(
                                                      color: customViolet[50],
                                                      child: InkWell(
                                                        child: Container(
                                                          height: 200,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  16),
                                                          child: Row(
                                                            children: [
                                                              Image.network(s
                                                                  .data.poster),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    Movie.cropStrings(
                                                                        s.data
                                                                            .title,
                                                                        26,
                                                                        threeDots:
                                                                            true),
                                                                    style: TextStyle(
                                                                        color:
                                                                            customAmber,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Text(
                                                                    s.data.year,
                                                                    style: TextStyle(
                                                                        color:
                                                                            customAmber,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          Movie movie = s.data;
                                                          if (movie != null) {
                                                            Navigator.of(
                                                                    context)
                                                                .push(
                                                                    MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      MovieSheet(
                                                                          movie),
                                                            ))
                                                                .then((value) {
                                                              futureMovies =
                                                                  _getFavMovies();
                                                              futureReviews =
                                                                  _getReviews();
                                                              futureReviews
                                                                  .then(
                                                                      (value) {
                                                                reviews = value;
                                                              });
                                                            });
                                                          } else {
                                                            return CircularProgressIndicator();
                                                          }
                                                        },
                                                      ),
                                                    ),
                                            );
                                          }
                                        });
                                  }),

                              Container(
                                height: 200.0,
                                child: ListView.separated(
                                  itemCount: reviews.length,
                                  itemBuilder: (context, index) {
                                    if (reviews.length == 0) {
                                      return CircularProgressIndicator();
                                    }
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: customViolet[700],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(16))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      reviews[index]['Title'],
                                                      style: TextStyle(
                                                        color: customAmber,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    Text(
                                                      reviews[index]
                                                          ['Description'],
                                                      style: TextStyle(
                                                        color: customAmber,
                                                      ),
                                                    ),
                                                  ],
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
                                                              FractionalOffset
                                                                  .center,
                                                          image: Image.network(
                                                                  reviews[index]
                                                                      ['Photo'])
                                                              .image,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      reviews[index]
                                                          ['Username'],
                                                      style: TextStyle(
                                                        color: customAmber,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      reviews[index]['Rate']
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: customAmber,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          SizedBox(
                                    height: 10,
                                  ),
                                ),
                              )

                              // Center(
                              //     child: Expanded(
                              //         child: Container(
                              //             child: Text(
                              //                 'Show comments not avaiable in these release. Thanks for your patience',
                              //                 style: TextStyle(
                              //                     color: Colors.white))))),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget navBar(BuildContext context) {
    return TabBar(
      tabs: myTabs,
      controller: _tabController,
    );
  }

  Future<List<Map<String, dynamic>>> _getReviews() async {
    List<Map<String, dynamic>> newReviews = [];
    Stream<QuerySnapshot> snapshot = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.email)
        .collection('films')
        .snapshots();
    //User currentUser = FirebaseAuth.instance.currentUser;
    snapshot.forEach((element) {
      List<DocumentSnapshot> docs = element.docs;
      if (docs.length == 0) return null;
      setState(() {
        docs.forEach(
          (el) {
            if (el.data().isNotEmpty && el.data()['Reviews'] != null) {
              for (Map<String, dynamic> review in el.data()['Reviews']) {
                newReviews.add(review);
              }
            } //fMovies.add(Movie.fetchMovie(element.id));
          },
        );
      });
    });
    return newReviews;
  }
}
