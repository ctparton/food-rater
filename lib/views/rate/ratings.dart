import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_rater/models/anim_type.dart';
import 'package:food_rater/models/food_rating_model.dart';
import 'package:food_rater/views/common/loading_spinner.dart';
import 'package:food_rater/views/rate/ratings_detail.dart';
import 'package:food_rater/views/settings.dart';
import 'package:provider/provider.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'dart:math' as math;

/// A class to handle the list of ratings
class Ratings extends StatefulWidget {
  @override
  _RatingsState createState() => _RatingsState();
}

class _RatingsState extends State<Ratings> {
  /// Controls the state of the search bar
  final SearchBarController<FoodRating> _searchBarController =
      SearchBarController();

  bool sortedDescending = true;
  @override
  Widget build(BuildContext context) {
    final _ratings = Provider.of<List<FoodRating>>(context);
    // By default, sort ratings in descending order
    if (_ratings != null && sortedDescending) {
      _ratings.sort((a, b) => b.rating.compareTo(a.rating));
    }

    /// Returns the filtered _ratings list based on the [search] query
    Future<List<FoodRating>> handleSearchQuery(String search) async {
      return search == "empty"
          ? _ratings
          : _ratings
              .where((element) => element.rName
                  .toLowerCase()
                  .trim()
                  .contains(search.toLowerCase()))
              .toList();
    }

    return _ratings != null
        ? Scaffold(
            appBar: AppBar(
              title: Text("FoodMapr"),
              actions: <Widget>[
                !sortedDescending
                    ? IconButton(
                        icon: Icon(
                          Icons.sort_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            sortedDescending = !sortedDescending;
                          });
                        },
                      )
                    : Transform.rotate(
                        // If sorted in ascending order, flip the icon
                        angle: 180 * math.pi / 180,
                        child: IconButton(
                          icon: Icon(
                            Icons.sort,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              sortedDescending = !sortedDescending;
                              _ratings
                                  .sort((a, b) => a.rating.compareTo(b.rating));
                            });
                          },
                        ),
                      ),
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
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SearchBar<FoodRating>(
                    searchBarStyle: SearchBarStyle(
                      backgroundColor: Colors.grey[400],
                      padding: EdgeInsets.all(10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    searchBarController: _searchBarController,
                    minimumChars: 2,
                    hintText: "Search by restaurant name",
                    hintStyle: TextStyle(
                        color: Colors.grey[100], fontWeight: FontWeight.w300),
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    emptyWidget: Text("No results found"),
                    placeHolder: _ratings.length > 0
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: _ratings.length ?? 0,
                            itemBuilder: (BuildContext ctxt, int index) =>
                                buildRatingCard(_ratings[index]))
                        : Column(
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                "You have not made any ratings yet!",
                                style: TextStyle(fontSize: 30),
                              ),
                              SvgPicture.asset(
                                "assets/035-recipebook.svg",
                                width: 300,
                                height: 300,
                              )
                            ],
                          ),
                    onSearch: handleSearchQuery,
                    onItemFound: (FoodRating rating, int index) {
                      return buildRatingCard(rating);
                    },
                  ),
                ),
              ),
            ),
          )
        : LoadingSpinner(animationType: AnimType.loading);
  }

  /// Creates an individual ratings card, consisting of the restaruant name,
  /// meal and rating
  Widget buildRatingCard(FoodRating rating) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RatingsDetail(detail: rating),
              ),
            );
          },
          child: Column(children: [
            Padding(padding: const EdgeInsets.only(top: 8.0, bottom: 8.0)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Text(
                  rating.rName,
                  style: TextStyle(fontSize: 30),
                ),
                Spacer()
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [Text(rating.mealName), Spacer()]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Text(rating.rating.toString()),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ImageIcon(
                    AssetImage("assets/heart.png"),
                    color: Colors.pink,
                  ),
                )
              ]),
            ),
          ]),
        ),
      ),
    ));
  }
}
