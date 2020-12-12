import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
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
    futureMovies = Movie.fetchMovie("Batman");
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
      appBar: AppBar(
        title: Text("CinemaTalk"),
      ),
      body: FutureBuilder(
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
      ),
      //   TextField(
      //     controller: _controller,
      //     onSubmitted: (value) {
      //       setState(() {
      //         futureMovies = fetchMovie(value);
      //       });
      //     },
      //   ),
      // ]),
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
