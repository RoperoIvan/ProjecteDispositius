import 'package:flutter/material.dart';
import 'package:projectdisp/custom_colors.dart';

class EmailAndPassword {
  String email, password;
  EmailAndPassword(this.email, this.password);
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _email, _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40),
              Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 24,
                  color: customViolet[50],
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: _email,
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
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 20),
              FlatButton(
                height: 50,
                color: customAmber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  ),
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: customViolet,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(
                    EmailAndPassword(
                      _email.text,
                      _password.text,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
