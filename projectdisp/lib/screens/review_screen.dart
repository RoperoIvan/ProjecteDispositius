import 'package:flutter/material.dart';
import 'package:projectdisp/custom_colors.dart';
import 'rate_screen.dart';
import '../model/review.dart';
import '../model/movie.dart';

class ReviewScreen extends StatefulWidget {
  final Movie movie;

  ReviewScreen({this.movie});
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  TextEditingController _titleController;
  TextEditingController _bodyController;
  Review _newReview;
  bool _isTitle;
  bool _isbody;
  int _rate;
  @override
  void initState() {
    _titleController = TextEditingController();
    _bodyController = TextEditingController();
    _isTitle = false;
    _isbody = false;
    _rate = 0;
    _newReview = Review();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a review'),
        actions: [
          FlatButton(
            child: Text(
              "Post",
              style: TextStyle(color: customAmber, fontSize: 18),
            ),
            onPressed: () {
              Navigator.of(context).pop(_newReview);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 50),
            TextField(
              style: TextStyle(color: Colors.white),
              controller: _titleController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: customViolet, width: 2.0),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                ),
                labelStyle:
                    TextStyle(color: _isTitle ? Colors.white : Colors.grey),
                labelText: 'Title',
              ),
              onTap: () {
                setState(() {
                  _isTitle = true;
                });
              },
              onChanged: (value) {
                setState(() {
                  _newReview.title = value;
                });
              },
              onSubmitted: (value) {
                setState(() {
                  _newReview.title = value;
                });
              },
            ),
            SizedBox(height: 50),
            TextField(
              style: TextStyle(color: Colors.white),
              controller: _bodyController,
              maxLines: 10,
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: customViolet, width: 2.0),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                ),
                labelStyle:
                    TextStyle(color: _isbody ? Colors.white : Colors.grey),
                labelText: 'Description',
                alignLabelWithHint: true,
              ),
              onTap: () {
                setState(() {
                  _isbody = !_isbody;
                });
              },
              onChanged: (value) {
                setState(() {
                  _newReview.body = value;
                });
              },
              onSubmitted: (value) {
                setState(() {
                  _newReview.body = value;
                });
              },
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                    builder: (context) => RateScreen(widget.movie),
                  ))
                      .then((value) {
                    _newReview.rate = value.toString();
                  });
                },
                child: Text("Rate"))
          ],
        ),
      ),
    );
  }
}
