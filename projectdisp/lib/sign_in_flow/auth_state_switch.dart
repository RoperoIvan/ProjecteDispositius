import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'screens/sign_in_screen.dart';

class AuthStateSwitch extends StatelessWidget {
  final Widget app;
  AuthStateSwitch({@required this.app});

  Widget _buildSplash(String msg){
    return  MaterialApp(
            home: Scaffold(
              body: Center(child: Text(msg)),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User> snapshot) {
        if (snapshot.hasError) {
          return _buildSplash(snapshot.error.toString());
        }
        switch(snapshot.connectionState){
          
          case ConnectionState.waiting:
            _buildSplash("...loading");
            break;
          case ConnectionState.active:{
            final user = snapshot.data;
            if(user == null){
              return MaterialApp( home: SignInScreen());
            }else{
              return this.app;
            }
          } 
          break;
            case ConnectionState.done:
            return _buildSplash("unrechable (done!)");
            break;
          default:
            return _buildSplash("unrechable (none!)");
            break;
         
        }
      },
    );
  }
}
