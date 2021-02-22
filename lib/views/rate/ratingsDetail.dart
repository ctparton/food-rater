import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(detail.mealName,
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold)),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Consumed on: ${detail.date}",
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.w300))),
                Container(
                    height: 100,
                    child: Card(
                      color: Colors.green,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(children: [Text("Rating")]),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RatingBar(
                                initialRating: detail.rating,
                                ignoreGestures: true,
                                onRatingUpdate: (value) => null,
                                ratingWidget: RatingWidget(
                                  full: Image(
                                      image: AssetImage('assets/heart.png')),
                                  half: Image(
                                      image:
                                          AssetImage('assets/heart_half.png')),
                                  empty: Image(
                                      image: AssetImage(
                                          'assets/heart_border.png')),
                                ),
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0)),
                          ),
                        ],
                      ),
                    )),
                Card(
                  color: Colors.green,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [Text("Comments")]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(detail.comments),
                      )
                    ],
                  ),
                ),
                Card(
                  color: Colors.green,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [Text("Recipes")]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("fetch recipes here"),
                      )
                    ],
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
