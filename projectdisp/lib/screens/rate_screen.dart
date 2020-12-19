import 'package:flutter/material.dart';
import 'package:projectdisp/custom_colors.dart';
import '../model/movie.dart';

class RateScreen extends StatefulWidget {
  final Movie movie;

  RateScreen(this.movie);
  @override
  _RateScreenState createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {
  String _title;
  @override
  void initState() {
    _title = widget.movie.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                  icon: Icon(Icons.close, color: customAmber),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ),
            Image.network(widget.movie.poster),
            Center(
              child: Text("Did you like $_title?",
                  style: TextStyle(
                    color: customAmber,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _RateIcon(rate: 1),
                    _RateIcon(rate: 2),
                    _RateIcon(rate: 3),
                    _RateIcon(rate: 4),
                    _RateIcon(rate: 5),
                    _RateIcon(rate: 6),
                    _RateIcon(rate: 7),
                    _RateIcon(rate: 8),
                    _RateIcon(rate: 9),
                    _RateIcon(rate: 10)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _RateIcon extends StatelessWidget {
  final int rate;
  _RateIcon({
    this.rate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      child: IconButton(
          icon: Icon(
            Icons.star_border,
            color: customAmber,
          ),
          onPressed: () {
            Navigator.of(context).pop(rate);
          }),
    );
  }
}
