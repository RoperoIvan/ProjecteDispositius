import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectdisp/custom_colors.dart';
import '../../model/user_app.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  UserApp user;
  SignInScreen({UserApp user})
  {
    this.user = user;
  }

  _SignInScreenState createState() => _SignInScreenState(user: user);
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _username, _password;
  UserApp userApp;

  _SignInScreenState({@required UserApp user})
  {
    userApp = user;
  }

  @override
  void initState() {
    _username = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.all(32),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.person,
                size: 120,
                color: customAmber,
              ),
              TextField(
                controller: _username,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 12),
              TextField(
                autocorrect: false,
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 12),
              GestureDetector(
                  child: Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 16,
                      color: customAmber,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (_) => SignUpScreen(),
                      ),
                    )
                        .then((result) {
                      _createUserWithEmailAndPassword(
                          email: result.email, password: result.password);
                    });
                  }),
              SizedBox(height: 30),
              FlatButton(
                color: customAmber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  ),
                height: 50,
                child: Text(
                  'Sign-in',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: customViolet,
                  ),
                ),
                onPressed: () {
                  _SignInWithEmailWithPassword(
                    username: _username.text,
                    password: _password.text,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ));
  }

  void _createUserWithEmailAndPassword({String email, String password}) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((user) {
      userApp = UserApp(
          userName: user.user.displayName,
          userId: user.user.uid,
          userEmail: user.user.email);

      Map<String, dynamic> newUser = {
        'UserName': userApp.userName,
        'UserId': userApp.userId,
        'UserEmail': userApp.userEmail
      };
      FirebaseFirestore.instance
          .collection('users')
          .doc(userApp.userEmail)
          .set(newUser);
      
      FirebaseAuth.instance.currentUser.updateProfile(displayName: userApp.userEmail);
    });
  }

  // ignore: non_constant_identifier_names
  void _SignInWithEmailWithPassword({String username, String password}) async {
    try {
      FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username,
        password: password,
      );
    } catch (e) {
      _showError(e);
    }
  }

  void _showError(error) {
    String message;
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case "wrong-password":
        case "user-not-found":
          message = "Wrong user/password combination";
          break;
        case "invalid-email":
          message = "The email is invalid";
          break;
        case "too-many-requests":
          message = "Too many login attempts. Try again later";
          break;
        case "weak-password":
          message = "The password is too weak";
          break;
        default:
          message = "FirebaseAuth Error: ${error.code}";
      }
    } else {
      message = "General Error: $error";
    }

    ScaffoldMessenger(
      child: SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
