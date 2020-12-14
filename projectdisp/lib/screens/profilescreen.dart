import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: RaisedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: Text(
              "Logout",
            )),
      ),
    );
  }
}
