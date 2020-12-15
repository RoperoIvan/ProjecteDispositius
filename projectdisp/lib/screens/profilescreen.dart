import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile"), actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: Center(
            child: GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
              child: Text("Logout"),
            ),
          ),
        )
      ]),
    );
  }
}
