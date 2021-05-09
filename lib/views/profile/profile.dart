import 'package:flutter/material.dart';
import 'package:food_rater/models/anim_type.dart';
import 'package:food_rater/views/common/loading_spinner.dart';
import 'package:food_rater/views/common/custom_app_bar.dart';
import 'package:food_rater/views/profile/profile_stat.dart';
import 'package:provider/provider.dart';
import 'package:food_rater/models/app_user_model.dart';
import 'package:food_rater/models/food_rating_model.dart';
import 'package:intl/intl.dart';
import 'package:food_rater/services/auth.dart';

/// A Profile class to show the user their current stats such as when they
/// joined FoodMapr and their total ratings.
class Profile extends StatelessWidget {
  /// Returns a [String] of the most popular cuisine rated
  String getMostPopularCuisine(ratings) {
    if (!ratings.isEmpty) {
      List cusine = ratings.map((e) => e.cuisine).toList();

      // Gets the most popular type of cuisine in the users ratings by finding
      // the cusine with the most occurences
      return cusine.toSet().reduce((i, j) =>
          cusine.where((v) => v == i).length >
                  cusine.where((v) => v == j).length
              ? i
              : j);
    }
    return null;
  }

  /// Calculates the total (unique) meals ate, total restaurants visited, total
  /// countries visited and most popular cuisine rated from the users [List<FoodRating>]
  /// ratings and returns these stats in a [Map<String, dynamic>]
  Map<String, dynamic> getUserStats(List<FoodRating> ratings) {
    dynamic mostPopularCuisine = getMostPopularCuisine(ratings);
    dynamic totalMeals = ratings
        .map((e) => e.mealName != null ? e.mealName.toLowerCase().trim() : null)
        .toSet();

    totalMeals.removeWhere((e) => e == null);

    dynamic totalRestaurants = ratings
        .map((e) => e.rName != null ? e.rName.toLowerCase().trim() : null)
        .toSet();

    totalRestaurants.removeWhere((e) => e == null);

    dynamic totalCountries = ratings
        // get the country from location string in form e.g. town, city, country
        .map((e) => e.rLocation.split(",").removeLast() != null
            ? e.rLocation.split(",").removeLast().toLowerCase().trim()
            : null)
        .toSet();

    totalCountries.removeWhere((e) => e == null);

    return {
      "totalMeals": totalMeals?.length ?? 0,
      "totalRestaurants": totalRestaurants?.length ?? 0,
      "totalCountries": totalCountries?.length ?? 0,
      "mostPopular": mostPopularCuisine
    };
  }

  @override
  Widget build(BuildContext context) {
    /// Auth service to retrieve current user statistics
    final AuthService _auth = AuthService();

    /// Collection of ratings that the user has made
    final _ratings = Provider.of<List<FoodRating>>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
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
    Map<String, dynamic> userStats = getUserStats(ratings);

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
        ProfileStat(
          statText: "You joined FoodMapr on:",
          userStat: DateFormat('dd-MM-yyyy').format(user.created).toString(),
          statIcon: Icons.date_range,
        ),
        ProfileStat(
          statText: "Restaurants Rated:",
          userStat: userStats['totalRestaurants'],
          statIcon: Icons.star,
        ),
        ProfileStat(
          statText: "Meals rated:",
          userStat: userStats['totalMeals'],
          statIcon: Icons.local_dining,
        ),
        ProfileStat(
          statText: "Countries visited:",
          userStat: userStats['totalCountries'],
          statIcon: Icons.location_on,
        ),
        userStats['mostPopular'] == null
            ? ProfileStat(
                statText: "You do not have a most rated cuisine yet",
                userStat: "",
                statIcon: Icons.food_bank_sharp,
              )
            : ProfileStat(
                statText: "Most rated cuisine",
                userStat: userStats['mostPopular'],
                statIcon: Icons.food_bank_sharp,
              ),
      ],
    );
  }
}
