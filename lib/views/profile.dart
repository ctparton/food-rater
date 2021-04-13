import 'package:flutter/material.dart';
import 'package:food_rater/models/anim_type.dart';
import 'package:food_rater/views/common/loading_spinner.dart';
import 'package:food_rater/views/common/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:food_rater/models/app_user_model.dart';
import 'package:food_rater/models/food_rating_model.dart';
import 'package:intl/intl.dart';
import 'package:food_rater/services/auth.dart';

/// A Profile class to show the user their current stats such as when they
/// joined FoodMapr and their total ratings
class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// Auth service to retrieve current user statistics
    final AuthService _auth = AuthService();

    /// Collection of ratings that the user has made
    final _ratings = Provider.of<List<FoodRating>>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: FoodMaprAppBar(),
      ),
      body: Container(
        // full device width
        width: MediaQuery.of(context).size.width,
        // Once ratings have been loaded, display the profile
        child: _ratings != null
            ? Column(
                children: [
                  displayProfile(_auth.getSignedInUser(), context, _ratings)
                ],
              )
            : LoadingSpinner(animationType: AnimType.loading),
      ),
    );
  }

  /// Displays the profile of the user as well as the total meals/restaurants they have rated,
  /// the type of cuisine they have most frequently rated and the total countries visited
  Widget displayProfile(AppUser user, context, ratings) {
    dynamic mostPopular;

    dynamic totalMeals = ratings
        .map((e) => e.mealName != null ? e.mealName.toLowerCase().trim() : null)
        .toSet();

    dynamic totalRestaurants = ratings
        .map((e) => e.rName != null ? e.rName.toLowerCase().trim() : null)
        .toSet();

    dynamic totalCountries = ratings
        // get the country from location string in form e.g. town, city, country
        .map((e) => e.rLocation.split(",").removeLast() != null
            ? e.rLocation.split(",").removeLast().toLowerCase().trim()
            : null)
        .toSet();

    if (!ratings.isEmpty) {
      List cusine = ratings.map((e) => e.cuisine).toList();
      // Gets the most popular type of cuisine in the users ratings
      mostPopular = cusine.toSet().reduce((i, j) =>
          cusine.where((v) => v == i).length >
                  cusine.where((v) => v == j).length
              ? i
              : j);
    }

    totalMeals.removeWhere((e) => e == null);
    totalRestaurants.removeWhere((e) => e == null);
    totalCountries.removeWhere((e) => e == null);

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
            style: TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(children: [
            Text(
              "Stats",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.date_range),
            ),
            Text(
              "You joined FoodMapr on: ${DateFormat('dd-MM-yyyy').format(user.created).toString()}",
              style: TextStyle(fontSize: 20),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.star),
            ),
            Text(
              "Restaurants rated: ${totalRestaurants?.length ?? 0}",
              style: TextStyle(fontSize: 20),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.local_dining),
            ),
            Text(
              "Meals rated: ${totalMeals?.length ?? 0}",
              style: TextStyle(fontSize: 20),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.location_on),
            ),
            Text(
              "Countries visited: ${totalCountries?.length ?? 0}",
              style: TextStyle(fontSize: 20),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.food_bank_sharp),
            ),
            mostPopular != null
                ? Text(
                    "Most rated cuisine: $mostPopular",
                    style: TextStyle(fontSize: 20),
                  )
                : Text(
                    "You do not have a most rated cuisine yet",
                    style: TextStyle(fontSize: 20),
                  ),
          ]),
        ),
      ],
    );
  }
}
