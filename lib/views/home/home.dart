import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_rater/models/foodrating.dart';
import 'package:food_rater/views/map/map.dart';
import 'package:animations/animations.dart';
import 'package:food_rater/views/rate/ratings.dart';
import 'package:food_rater/views/rate/review.dart';
import 'package:food_rater/views/test.dart';
import 'package:food_rater/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:food_rater/services/firestoreService.dart';
import 'package:food_rater/models/appuser.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentPage = 0;
  final AuthService _auth = AuthService();

  final page = [Ratings(), MapState(), Review(), Test()];

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AppUser>(context);

    return StreamProvider<List<FoodRating>>.value(
      value: FirestoreServce(uid: _user.uid).ratings,
      child: Scaffold(
        appBar: AppBar(
          title: Text("FoodMapr"),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () async {
                dynamic result = await _auth.signOut();
              },
            )
          ],
        ),
        body: PageTransitionSwitcher(
          transitionBuilder: (Widget child, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
          child: IndexedStack(index: _currentPage, children: page),
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.amber[800],
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentPage,
          onTap: (index) => setState(() => _currentPage = index),
          items: [
            BottomNavigationBarItem(
                label: "Rating", icon: Icon(Icons.local_library_sharp)),
            BottomNavigationBarItem(label: "Map", icon: Icon(Icons.map)),
            BottomNavigationBarItem(
                label: "Review", icon: Icon(Icons.rate_review_outlined)),
            BottomNavigationBarItem(
                label: "Profile", icon: Icon(Icons.update_sharp))
          ],
        ),
      ),
    );
  }
}
