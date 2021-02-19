import 'package:flutter/material.dart';
import 'package:food_rater/models/foodrating.dart';

class RatingsDetail extends StatelessWidget {
  final FoodRating detail;

  RatingsDetail({this.detail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: Text(detail.rName),
              expandedHeight: 350.0,
              flexibleSpace: FlexibleSpaceBar(
                background: detail.getImage(),
              ),
            ),
            SliverFixedExtentList(
                delegate: SliverChildListDelegate(
                    [Text(detail.rCity), Text(detail.image ?? "No image")]),
                itemExtent: 200.0)
          ],
        ),
      ),
    );
  }
}
