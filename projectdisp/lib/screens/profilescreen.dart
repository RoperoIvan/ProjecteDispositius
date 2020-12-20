import 'package:flutter/material.dart';
import '../custom_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'homescreen.dart';
import 'editProfileScreen.dart';
import 'search_page.dart';
import '../model/movie.dart';
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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                              // StreamBuilder(
                              //     stream: FirebaseFirestore.instance
                              //         .collection('users')
                              //         .doc(
                              //             FirebaseAuth.instance.currentUser.email)
                              //         .collection('films')
                              //         .snapshots(),
                              //     builder: (context,
                              //         AsyncSnapshot<QuerySnapshot> snapshot) {
                              //       // Construir un widget en función de los datos
                              //       if (!snapshot.hasData) {
                              //         return Center(
                              //           child: Text('No favorite films'),
                              //         );
                              //       }
                              //       List<DocumentSnapshot> docs =
                              //           snapshot.data.docs;
                              //       if (docs.isEmpty)
                              //         return Center(
                              //             child: Text(
                              //                 'List of favorite films is empty'));

                              //       List<Movie> filmsID;
                              //       filmsID = [];
                              //       docs.forEach((element) {
                              //         if (element.data()['Favourite'] == true) {
                              //           Movie.fetchMovie(element.id).then((value){
                              //             filmsID.add(value);
                              //           }).whenComplete((){
                                          
                              //           });
                              //         } else
                              //           return CircularProgressIndicator();
                              //       });
                              //       if (filmsID.isNotEmpty) {
                              //         return ListView.builder(
                              //           itemCount: filmsID.length,
                              //           itemBuilder: (context, index) {
                              //                 Card(
                              //                   child: InkWell(
                              //                     child: Container(
                              //                       height: 200,
                              //                       width: MediaQuery.of(context)
                              //                           .size
                              //                           .width,
                              //                       padding: EdgeInsets.all(16),
                              //                       child: Row(
                              //                         children: [
                              //                           Image.network(
                              //                               snapshot.data[index].poster),
                              //                           Column(
                              //                             crossAxisAlignment:
                              //                                 CrossAxisAlignment
                              //                                     .start,
                              //                             children: [
                              //                               Text(snapshot.data[index].title,
                              //                                   style: TextStyle(
                              //                                       fontSize:
                              //                                           12)),
                              //                               Text(snapshot.data[index].year,
                              //                                   style: TextStyle(
                              //                                       fontSize:
                              //                                           10)),
                              //                             ],
                              //                           )
                              //                         ],
                              //                       ),
                              //                     ),
                              //                     onTap: () {
                              //                       Movie movie;
                              //                       Future<Movie> pickedMovie =
                              //                           Movie.fetchMovie(
                              //                               snapshot.data[index].title);
                              //                       pickedMovie.then((value) {
                              //                         movie = value;
                              //                         if (movie != null) {
                              //                           Navigator.of(context)
                              //                               .push(
                              //                                   MaterialPageRoute(
                              //                             builder: (context) =>
                              //                                 MovieSheet(movie),
                              //                           ));
                              //                         } else {
                              //                           return CircularProgressIndicator();
                              //                         }
                              //                       });
                              //                     },
                              //                   ),
                              //                 );                                      
                              //           },
                              //         );
                              //       } else {
                              //         return Center(
                              //             child: Text('no films avaiable now'));
                              //       }
                              //     }),
                              Center(
                                  child: Expanded(
                                      child:
                                          Container(child: Text('Show favourites films not avaiable in these release. Thanks for your patience', style: TextStyle(color: Colors.white),)))),
                              Center(
                                  child: Expanded(
                                      child:
                                          Container(child: Text('Show comments not avaiable in these release. Thanks for your patience', style: TextStyle(color: Colors.white))))),
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
}
