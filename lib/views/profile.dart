import 'package:flutter/material.dart';
import 'package:food_rater/views/common/loading_spinner.dart';
import 'package:provider/provider.dart';
import 'package:food_rater/models/appuser.dart';
import 'package:food_rater/models/foodrating.dart';
import 'package:intl/intl.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AppUser>(context);
    final _ratings = Provider.of<List<FoodRating>>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      child: _ratings != null
          ? Column(
              children: [displayProfile(_user, context, _ratings)],
            )
          : LoadingSpinner(),
    );
  }

  Widget displayProfile(AppUser user, context, ratings) {
    // print('Ratings are ${}');
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
          child: Text(
              "Restaurants rated: ${ratings.map((e) => e.rName.toLowerCase().trim()).toSet().length}"),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              "Meals rated: ${ratings.map((e) => e.mealName.toLowerCase().trim()).toSet().length}"),
        ),
      ],
    );
  }
}
