import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_rater/models/foodrating.dart';
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
        body: _ratings.length != null
            ? ListView.builder(
                itemCount: _ratings.length ?? 0,
                itemBuilder: (BuildContext ctxt, int index) {
                  String value = _ratings[index].toString();
                  return new InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RatingsDetail(detail: _ratings[index]),
                          ),
                        );
                      },
                      child: Card(child: Text(value)));
                })
            : Text("You have not made any ratings yet"));
  }
}
