import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:projectdisp/custom_colors.dart';
import '../model/movie.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen();
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _controller;
  Future<List<Movie>> futureMovies;

  @override
  void initState() {
    _controller = TextEditingController();
    futureMovies = Movie.fetchMovies("Batman");
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final db = FirebaseFirestore.instance;
    return Scaffold(
      body:Stack(
        children:[
      _Carousel(),
      _Tabs(),
        ],
      ),
      
      
      /*FutureBuilder(
        future: futureMovies,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Stack(children: [
                    Container(
                      height: 300,
                      width: 300,
                      child: FittedBox(
                        child: Image.network(snapshot.data[index].poster),
                        fit: BoxFit.fill,
                      ),
                    ),
                    Text(snapshot.data[index].title),
                  ]),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),*/
      //),
    );
  }

}
// Example how to get items from fire base
// body: StreamBuilder(
//   stream: db.collection('tareas').snapshots(),
//   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//     // Construir un widget en función de los datos
//     if (!snapshot.hasData) {
//       return Center(
//         child: CircularProgressIndicator(),
//       );
//     }
//     List<DocumentSnapshot> docs = snapshot.data.docs;
//     return ListView.builder(
//       itemCount: docs.length,
//       itemBuilder: (context, index) {
//         Map<String, dynamic> data = docs[index].data();
//         return ListTile(
//           leading: Checkbox(
//             value: data['done'],
//             onChanged: (value) {
//               db
//                   .collection('tareas')
//                   .doc(docs[index].id)
//                   .update({'done': value});
//             },
//           ),
//           title: Text(data['what']),
//           onLongPress: () {
//             db.collection('tareas').doc(docs[index].id).delete();
//           },
//         );
//       },
//     );
//   },
// ),


class _Carousel extends StatelessWidget{
  @override
  Widget build(BuildContext context){
      return Container(
        child: CarouselSlider(
        options: CarouselOptions(
           height: 200,
           autoPlay: true,
           aspectRatio: 16/9,
           ),
        items: [1,2,3,4,5].map((i) {
          return Builder(
              builder: (BuildContext context) {
                return Container(
                 width: MediaQuery.of(context).size.width,
                 margin: EdgeInsets.symmetric(horizontal: 1.0),
                 decoration: BoxDecoration(
                    color: customAmber
                  ),
                 child: Text('Movie $i', style: TextStyle(fontSize: 16.0),
                 textAlign: TextAlign.center,)
               );
              },
            );
         }).toList(),
        ),
      ); 
  }
}

/*class _Tabs extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: DefaultTabController(
  length: 2,
  child: Scaffold(
    body:TabBar(
        tabs: [
          Tab(),
          Tab(),
        ],
      ),
    ),
  TabBarView(
  children: [
    Icon(Icons.directions_car),
    Icon(Icons.directions_transit),
  ],
  ),
),
);
}
}
*/