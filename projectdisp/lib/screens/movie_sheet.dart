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
  bool _favourite;
  void initState() {
    _rate = TextEditingController();
    _favourite = false;
    saveFavouriteInfoInFireBase();
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
                  _SaveRateInfoIntoFireBase(a);
                },
              ),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('films')
                    .doc(widget.movie.title)
                    .collection('info')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  // Construir un widget en función de los datos
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List<DocumentSnapshot> docs = snapshot.data.docs;
                  if (docs.isEmpty) return Text('0.0');
                  num i = 0;
                  bool passRates = false;
                  docs.forEach((element) {
                    if (element.id == 'rates') passRates = true;

                    if (!passRates) ++i;
                  });
                  if (docs[i].data()['Average'] != null)
                    return Text(docs[i].data()['Average']);
                  else
                    return Text('0.0');
                }),
            Checkbox(
              value: _favourite,
              onChanged: (value) {
                User currentUser = FirebaseAuth.instance.currentUser;
                var favourite = {'Favourite': value};
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser.email)
                    .collection('films')
                    .doc(widget.movie.title)
                    .update(favourite);
                setState(() {
                  _favourite = value;
                });
              },
            )
          ],
        ));
  }

  void _SaveRateInfoIntoFireBase(String a) {
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
      if (value.exists) {
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
      currentUser.uid: a,
    };
    //save into films
    FirebaseFirestore.instance
        .collection('films')
        .doc(widget.movie.title)
        .get()
        .then((value) {
      if (value == null) {
        FirebaseFirestore.instance
            .collection('films')
            .doc(widget.movie.title)
            .collection('info')
            .doc('rates')
            .set(filmRate);
        SetAverage();
      } else {
        FirebaseFirestore.instance
            .collection('films')
            .doc(widget.movie.title)
            .collection('info')
            .doc('rates')
            .get()
            .then((value) {
          if (value.exists) {
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
          SetAverage();
        });
      }
    });
  }

  void SetAverage() {
    num grade = 0.0;
    FirebaseFirestore.instance
        .collection('films')
        .doc(widget.movie.title)
        .collection('info')
        .doc('rates')
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

        var average = {'Average': grade.toString()};

        FirebaseFirestore.instance
            .collection('films')
            .doc(widget.movie.title)
            .collection('info')
            .doc('rates')
            .update(average);
      }
    });
  }

  void saveFavouriteInfoInFireBase() {
    User currentUser = FirebaseAuth.instance.currentUser;
    var favourite = {'Favourite': false};
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email)
        .collection('films')
        .doc(widget.movie.title)
        .get()
        .then((value) {
      if (!value.exists) {
        //Check if document of the movie does not exists
        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.email)
            .collection('films')
            .doc(widget.movie.title)
            .set(favourite);
      } else {
        if (value.data()['Favourite'] == null) {
          //Check if fav field exists
          FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.email)
              .collection('films')
              .doc(widget.movie.title)
              .update(favourite);
        } else {
          FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.email)
              .collection('films')
              .doc(widget.movie.title)
              .get()
              .then((value) {
            setState(() {
              _favourite = value.data()['Favourite'];
            });
          });
        }
      }
    });
  }
}
