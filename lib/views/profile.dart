import 'package:flutter/material.dart';
import 'package:food_rater/models/anim_type.dart';
import 'package:food_rater/views/common/loading_spinner.dart';
import 'package:food_rater/views/settings.dart';
import 'package:provider/provider.dart';
import 'package:food_rater/models/app_user_model.dart';
import 'package:food_rater/models/food_rating_model.dart';
import 'package:intl/intl.dart';

/// A Profile class to show the user their current stats such as when they
/// joined FoodMapr and their total ratings
class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AppUser>(context);
    final _ratings = Provider.of<List<FoodRating>>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("FoodMapr"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ),
              );
            },
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: _ratings != null
            ? Column(
                children: [displayProfile(_user, context, _ratings)],
              )
            : LoadingSpinner(animationType: AnimType.loading),
      ),
    );
  }

  /// Displays the actual profile of the user as well as their stats
  Widget displayProfile(AppUser user, context, ratings) {
    dynamic mostPopular;
    dynamic totalMeals = ratings
        .map((e) => e.mealName != null ? e.mealName.toLowerCase().trim() : null)
        .toSet();

    dynamic totalRestaurants = ratings
        .map((e) => e.rName != null ? e.rName.toLowerCase().trim() : null)
        .toSet();

    if (!ratings.isEmpty) {
      List cusine = ratings.map((e) => e.cuisine).toList();
      // Gets the most popular type of cuisine in the users ratings
      mostPopular = cusine.toSet().reduce((i, j) =>
          cusine.where((v) => v == i).length >
                  cusine.where((v) => v == j).length
              ? i
              : j);
      totalMeals.removeWhere((e) => e == null);
      totalRestaurants.removeWhere((e) => e == null);
    }

    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.10),
        CircleAvatar(
          child: CircleAvatar(
            backgroundImage: user.photoURL != null
                ? AssetImage("assets/${user.photoURL}")
                : AssetImage("assets/icons8-user-male-skin-type-1-48.png"),
            radius: 30,
          ),
          radius: 50,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Hi ${user.displayName ?? ''}",
            style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(children: [
              Text("Stats", style: TextStyle(fontSize: 30)),
            ])),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.date_range),
              ),
              Text(
                  "You joined FoodMapr on: ${DateFormat('dd-MM-yyyy').format(user.created).toString()}",
                  style: TextStyle(fontSize: 20)),
            ])),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.star),
              ),
              Text("Restaurants rated: ${totalRestaurants.length}",
                  style: TextStyle(fontSize: 20)),
            ])),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.local_dining),
              ),
              Text("Meals rated: ${totalMeals.length}",
                  style: TextStyle(fontSize: 20)),
            ])),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.food_bank_sharp),
              ),
              mostPopular != null
                  ? Text("Most rated cuisine: $mostPopular",
                      style: TextStyle(fontSize: 20))
                  : Text("You do not have a most rated cuisine yet",
                      style: TextStyle(fontSize: 20)),
            ])),
      ],
    );
  }
}
