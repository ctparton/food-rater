import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    final _ratings = Provider.of<QuerySnapshot>(context);

    for (var doc in _ratings.docs) {
      print(doc);
    }
    return Scaffold(
        body: new ListView.builder(
            itemCount: _ratings.docs.length,
            itemBuilder: (BuildContext ctxt, int index) {
              String value = _ratings.docs[index]['rCity'];
              return new InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RatingsDetail(detail: value),
                      ),
                    );
                  },
                  child: Card(child: Text(value)));
            }));
  }
}
