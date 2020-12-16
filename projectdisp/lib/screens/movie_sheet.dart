import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/movie.dart';

class MovieSheet extends StatefulWidget {
  final Movie movie;

  MovieSheet(this.movie);

  @override
  _MovieSheetState createState() => _MovieSheetState();
}

class _MovieSheetState extends State<MovieSheet> {
  TextEditingController _rate;

  void initState() {
    _rate = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _rate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.movie.title),
        ),
        body: Column(
          children: [
            Text(widget.movie.title),
            Text(widget.movie.year),
            Text(widget.movie.baseRate),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextField(
                autocorrect: false,
                controller: _rate,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                  labelText: 'Rate',
                ),
                onSubmitted: (a) {
                  _SaveInfoIntoFireBase(a);
                },
              ),
            ),
            Text(_GetAverageGrade().toString()),
          ],
        ));
  }

  void _SaveInfoIntoFireBase(String a) {
    User currentUser = FirebaseAuth.instance.currentUser;

    var newRate = {'Rate': a};
    //save into user
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email)
        .collection('films')
        .doc(widget.movie.title)
        .get()
        .then((value) {
      if (value.data().containsKey('Rate')) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.email)
            .collection('films')
            .doc(widget.movie.title)
            .update(newRate);
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.email)
            .collection('films')
            .doc(widget.movie.title)
            .set(newRate);
      }
    });

    var filmRate = {
      currentUser.email: a,
    };
    //save into films
    FirebaseFirestore.instance
        .collection('films')
        .doc(widget.movie.title)
        .get()
        .then((value) {
      if (!value.exists) {
        FirebaseFirestore.instance
            .collection('films')
            .doc(widget.movie.title)
            .collection('info')
            .doc('rates')
            .set(filmRate);
      } else {
        FirebaseFirestore.instance
            .collection('films')
            .doc(widget.movie.title)
            .collection('info')
            .doc('rates')
            .get()
            .then((value) {
          if (value.data().containsKey('Rate')) {
            FirebaseFirestore.instance
                .collection('films')
                .doc(widget.movie.title)
                .collection('info')
                .doc('rates')
                .update(filmRate);
          } else {
            FirebaseFirestore.instance
                .collection('films')
                .doc(widget.movie.title)
                .collection('info')
                .doc('rates')
                .set(filmRate);
          }
        });
      }
    });
  }

  num _GetAverageGrade(){
  num grade = 0.0;
    FirebaseFirestore.instance
        .collection('films')
        .doc(widget.movie.title)
        .collection('info')
        .doc('rates')
        .get()
        .then(
          (value){
            if (value.exists) {
              Map<String, dynamic> map = value.data();
              map.forEach((key, val) {
                num x = num.parse(val);
                grade += x;
              });
              grade = grade / map.length;
              return grade;
            }
          });
    return grade;
  }
}
