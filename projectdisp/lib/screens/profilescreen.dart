import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _password, _newPassword, _repeatNewPassword;

  @override
  void initState() {
    _password = TextEditingController();
    _newPassword = TextEditingController();
    _repeatNewPassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _password.dispose();
    _newPassword.dispose();
    _repeatNewPassword.dispose();
    super.dispose();
  }

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
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _password,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                ),
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              controller: _newPassword,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                ),
                labelText: ' New password',
              ),
            ),
                        SizedBox(height: 20,),
            TextField(
              controller: _repeatNewPassword,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                ),
                labelText: ' Repeat new password',
              ),
            ),
                        SizedBox(height: 20,),

            FlatButton(
              color: Theme.of(context).primaryColor,
              height: 50,
              child: Text(
                'Change password',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                _ChangePassword(
                  password: _password.text,
                  newPassword: _newPassword.text,
                  repeatNewPassword: _repeatNewPassword.text,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _ChangePassword(
      {String password, String newPassword, String repeatNewPassword}) async {
    try {
      User currentUser = FirebaseAuth.instance.currentUser;

      var authCredentials = EmailAuthProvider.credential(
          email: currentUser.email, password: password);

      var authResult =
          await currentUser.reauthenticateWithCredential(authCredentials);
      if (newPassword != repeatNewPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Repeat password are rong'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        if (authResult.user != null) {
          currentUser.updatePassword(newPassword);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Password changed'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password are rong'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
