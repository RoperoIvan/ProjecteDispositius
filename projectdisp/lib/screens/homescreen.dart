import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/movie.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _controller;
  int _selectedIndex = 0;
  Future<Movie> futureMovie;

  Future<Movie> fetchMovie(String title) async {
    final response =
        await http.get('https://www.omdbapi.com/?t=$title&apikey=d2c50466');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Movie.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    _controller = TextEditingController();
    futureMovie = fetchMovie("Batman");
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text("CinemaTalk"),
      ),
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
      body: Center(
          child: FutureBuilder(
        future: futureMovie,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Text(snapshot.data.title),
                Text(snapshot.data.year),
                Image.network(snapshot.data.poster),
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      )),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            db
                .collection('tareas')
                .add({'done': false, 'what': "Hola que tal"});
          }),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
