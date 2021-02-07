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

    return Scaffold(
        body: new ListView.builder(
            itemCount: litems.length,
            itemBuilder: (BuildContext ctxt, int index) {
              String value = litems[index] + _user.uid;
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
