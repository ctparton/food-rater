import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_rater/models/foodrating.dart';
import 'package:food_rater/views/common/loading_spinner.dart';
import 'package:food_rater/views/rate/ratingsDetail.dart';
import 'package:provider/provider.dart';
import 'package:food_rater/models/appuser.dart';

class Ratings extends StatefulWidget {
  @override
  _RatingsState createState() => _RatingsState();
}

class _RatingsState extends State<Ratings> {
  List<String> litems =
      List<String>.generate(100, (int index) => 'test $index');

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AppUser>(context);
    final _ratings = Provider.of<List<FoodRating>>(context);

    print(_ratings);
    // for (var doc in _ratings) {
    //   print(doc);
    // }
    return Scaffold(
        body: _ratings != null
            ? _ratings.length > 0
                ? ListView.builder(
                    itemCount: _ratings.length ?? 0,
                    itemBuilder: (BuildContext ctxt, int index) =>
                        buildRatingCard(ctxt, index, _ratings))
                : Text("You have no ratings, make one!")
            : LoadingSpinner());
  }

  Widget buildRatingCard(
      BuildContext ctxt, int index, List<FoodRating> ratings) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RatingsDetail(detail: ratings[index]),
              ),
            );
          },
          child: Column(children: [
            Padding(padding: const EdgeInsets.only(top: 8.0, bottom: 8.0)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Text(
                  ratings[index].rName,
                  style: TextStyle(fontSize: 30),
                ),
                Spacer()
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [Text(ratings[index].mealName), Spacer()]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Text(ratings[index].rating.toString()),
                Spacer(),
                Icon(Icons.star)
              ]),
            ),
          ]),
        ),
      ),
    ));
  }
}
