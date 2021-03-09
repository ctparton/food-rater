import 'package:flutter/material.dart';
import 'package:food_rater/views/common/loading_spinner.dart';
import 'package:food_rater/views/settings.dart';
import 'package:provider/provider.dart';
import 'package:food_rater/models/app_user_model.dart';
import 'package:food_rater/models/food_rating_model.dart';
import 'package:intl/intl.dart';
import 'package:food_rater/services/auth.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AppUser>(context);
    final _ratings = Provider.of<List<FoodRating>>(context);
    final AuthService _auth = AuthService();

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
            : LoadingSpinner(),
      ),
    );
  }

  Widget displayProfile(AppUser user, context, ratings) {
    dynamic totalMeals = ratings
        .map((e) => e.mealName != null ? e.mealName.toLowerCase().trim() : null)
        .toSet();

    dynamic totalRestaurants = ratings
        .map((e) => e.rName != null ? e.rName.toLowerCase().trim() : null)
        .toSet();

    totalMeals.removeWhere((e) => e == null);
    totalRestaurants.removeWhere((e) => e == null);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Hi, ${user.displayName ?? ''}"),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              "You joined FoodMapr on: ${DateFormat('dd-MM-yyyy').format(user.created).toString()}"),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Restaurants rated: ${totalRestaurants.length}"),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Meals rated: ${totalMeals.length}"),
        ),
      ],
    );
  }
}
