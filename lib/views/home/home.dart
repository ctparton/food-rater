import 'package:flutter/material.dart';
import 'package:food_rater/models/food_rating_model.dart';
import 'package:food_rater/views/map/map.dart';
import 'package:animations/animations.dart';
import 'package:food_rater/views/rate/ratings.dart';
import 'package:food_rater/views/rate/review.dart';
import 'package:food_rater/views/profile.dart';
import 'package:provider/provider.dart';
import 'package:food_rater/services/firestore_service.dart';
import 'package:food_rater/models/app_user_model.dart';

/// The Home class which holds the [BottomNavigationBar] and passes the
/// list of [FoodRating] to the descendent Rating, Review, Profile and Map
/// pages
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentPage = 0;

  final pages = [Ratings(), MapState(), Review(), Profile()];

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AppUser>(context);

    // Provide the FoodRatings to all widgets
    return StreamProvider<List<FoodRating>>.value(
      value: FirestoreServce(uid: _user.uid).ratings,
      child: Scaffold(
        body: PageTransitionSwitcher(
          transitionBuilder: (Widget child, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
          // The Indexed Stack ensures the state of each tab is retained
          child: IndexedStack(index: _currentPage, children: pages),
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blue[800],
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentPage,
          onTap: (index) => setState(() => _currentPage = index),
          items: [
            BottomNavigationBarItem(
                label: "Rating", icon: Icon(Icons.local_dining)),
            BottomNavigationBarItem(label: "Map", icon: Icon(Icons.map)),
            BottomNavigationBarItem(
                label: "Review", icon: Icon(Icons.rate_review_outlined)),
            BottomNavigationBarItem(
                label: "Profile", icon: Icon(Icons.face_sharp))
          ],
        ),
      ),
    );
  }
}
