import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _password, _newPassword, _repeatNewPassword, _nick;
  File _image;
  String _name;
  _ProfileScreenState() {
    _name = FirebaseAuth.instance.currentUser.displayName;
  }
  @override
  void initState() {
    _password = TextEditingController();
    _newPassword = TextEditingController();
    _repeatNewPassword = TextEditingController();
    _nick = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _password.dispose();
    _newPassword.dispose();
    _repeatNewPassword.dispose();
    _nick.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$_name Profile"), actions: <Widget>[
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //photoEditor
              _showPhoto(),
              SizedBox(height: 20),
              FlatButton(
                color: Theme.of(context).primaryColor,
                height: 50,
                child: Text(
                  'Save Image',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  _UploadImageToFirebase();
                },
              ),
              SizedBox(height: 20),

              //nick editor
              TextField(
                controller: _nick,
                decoration: InputDecoration(
                  fillColor: Color(0xffFF006E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                  labelText: ' nick',
                ),
              ),
              SizedBox(height: 20),
              FlatButton(
                color: Theme.of(context).primaryColor,
                height: 50,
                child: Text(
                  'Change nick',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  FirebaseAuth.instance.currentUser
                        .updateProfile(displayName: _nick.text);
                  setState(() {
                    _name = _nick.text;
                  });
                },
              ),

              //password editor
              SizedBox(height: 20),
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
              SizedBox(
                height: 20,
              ),
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
              SizedBox(height: 20),
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
              SizedBox(height: 20),
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

  GestureDetector _showPhoto() {
    return GestureDetector(
      child: CircleAvatar(
        radius: 55,
        backgroundColor: Color(0xffFF006E),
        child: FirebaseAuth.instance.currentUser.photoURL != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  FirebaseAuth.instance.currentUser.photoURL,
                  width: 100,
                  height: 100,
                  fit: BoxFit.fitHeight,
                ),
              )
            : Container(
                decoration: BoxDecoration(
                    color: Color(0xffFF006E),
                    borderRadius: BorderRadius.circular(50)),
                width: 100,
                height: 100,
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.grey[800],
                ),
              ),
      ),
      onTap: () => _showPicker(context),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromCamera() async {
    PickedFile image = await ImagePicker.platform
        .pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = File(image.path);
    });
  }

  _imgFromGallery() async {
    PickedFile image = await ImagePicker.platform
        .pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(image.path);
    });
  }

  Future _UploadImageToFirebase() async {
    String fileName = FirebaseAuth.instance.currentUser.email;
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then(
          (value) => print("Done: $value"),
        );
    _assignValueImage();
  }

  Future _assignValueImage() async {
    String fileName = FirebaseAuth.instance.currentUser.email;
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    String aux = await firebaseStorageRef.getDownloadURL();

    FirebaseAuth.instance.currentUser.updateProfile(photoURL: aux);
  }
}
