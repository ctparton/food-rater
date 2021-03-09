import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_rater/models/food_rating_model.dart';
import 'package:food_rater/views/common/loading_spinner.dart';
import 'package:food_rater/views/rate/ratings_detail.dart';
import 'package:provider/provider.dart';
import 'package:food_rater/models/app_user_model.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:food_rater/services/auth.dart';
import 'dart:math' as math;

class Ratings extends StatefulWidget {
  @override
  _RatingsState createState() => _RatingsState();
}

class _RatingsState extends State<Ratings> {
  final SearchBarController<FoodRating> _searchBarController =
      SearchBarController();
  final AuthService _auth = AuthService();
  bool sortedDescending = true;
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AppUser>(context);
    final _ratings = Provider.of<List<FoodRating>>(context);
    if (_ratings != null && sortedDescending) {
      _ratings.sort((a, b) => b.rating.compareTo(a.rating));
    }
    Future<List<FoodRating>> search(String search) async {
      return search == "empty"
          ? _ratings
          : _ratings
              .where((element) => element.rName
                  .toLowerCase()
                  .trim()
                  .contains(search.toLowerCase()))
              .toList();
    }

    print(_ratings);

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
                        angle: 180 * math.pi / 180,
                        child: IconButton(
                          icon: Icon(
                            Icons.sort,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            print(_ratings);
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
                    dynamic result = await _auth.signOut();
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
                                buildRatingCard(index, _ratings))
                        : Text("You have no ratings, make one!"),
                    onSearch: search,
                    onItemFound: (FoodRating post, int index) {
                      return buildRatingCards(index, post);
                    },
                  ),
                ),
              ),
            ),
          )
        : LoadingSpinner();
  }

  Widget buildRatingCard(int index, List<FoodRating> ratings) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RatingsDetail(detail: ratings[index]),
              ),
            );
          },
          child: Column(children: [
            Padding(padding: const EdgeInsets.only(top: 8.0, bottom: 8.0)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Text(
                  ratings[index].rName,
                  style: TextStyle(fontSize: 30),
                ),
                Spacer()
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [Text(ratings[index].mealName), Spacer()]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Text(ratings[index].rating.toString()),
                Spacer(),
                Icon(Icons.star)
              ]),
            ),
          ]),
        ),
      ),
    ));
  }

  Widget buildRatingCards(int index, FoodRating ratings) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RatingsDetail(detail: ratings),
              ),
            );
          },
          child: Column(children: [
            Padding(padding: const EdgeInsets.only(top: 8.0, bottom: 8.0)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Text(
                  ratings.rName,
                  style: TextStyle(fontSize: 30),
                ),
                Spacer()
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [Text(ratings.mealName), Spacer()]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Text(ratings.rating.toString()),
                Spacer(),
                Icon(Icons.star)
              ]),
            ),
          ]),
        ),
      ),
    ));
  }
}
