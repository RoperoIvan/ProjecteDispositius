import 'package:flutter/material.dart';
import '../model/review.dart';
import '../custom_colors.dart';

class ReviewItem extends StatefulWidget {
  final Review review;
  ReviewItem({this.review});
  @override
  _ReviewItemState createState() => _ReviewItemState();
}

class _ReviewItemState extends State<ReviewItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: customViolet[700],
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Column(
              children: [
                Text(widget.review.title),
                Text(widget.review.body),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
