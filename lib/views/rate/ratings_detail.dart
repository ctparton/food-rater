import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_rater/models/food_rating_model.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:food_rater/services/recipe_service.dart';
import 'package:provider/provider.dart';
import 'package:food_rater/models/app_user_model.dart';
import 'package:food_rater/services/firestore_service.dart';
import 'package:food_rater/models/recipe_model.dart';
import 'package:url_launcher/url_launcher.dart';

/// A class which creates the Ratings Detail Page to display the details of a
/// particular rating
class RatingsDetail extends StatefulWidget {
  final FoodRating detail;

  RatingsDetail({this.detail});
  @override
  _RatingsDetailState createState() => _RatingsDetailState();
}

/// A class to hold the state of the page and display the information
class _RatingsDetailState extends State<RatingsDetail> {
  /// Recipe service instance to get recipe information
  final RecipeService recipeService = RecipeService();

  /// Key to hold the current state of the form
  final _formKey = GlobalKey<FormBuilderState>();
  Future<Recipe> recipeRes;
  bool showIngredients = false;

  // When the state is initialised, make a request to get recipe information
  initState() {
    super.initState();
    recipeRes = recipeService.getRecipe(widget.detail.mealName);
  }

  // Rating and comment are not final, these can be be updated by the user
  double rating;
  String comments;
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AppUser>(context);
    rating = widget.detail.rating;
    comments = widget.detail.comments;
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          // Build app bar with large image that is gradually hidden upon scroll
          slivers: <Widget>[
            SliverAppBar(
              title: Text(widget.detail.rName),
              expandedHeight: 350.0,
              flexibleSpace: FlexibleSpaceBar(
                background: widget.detail.getImage(),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _ratingEditBottomModal(context, _user),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _ratingDeleteBottomModal(context, _user),
                )
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.detail.mealName,
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Consumed on: ${widget.detail.date}",
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey[700]),
                  ),
                ),
                // Build read-only rating bar
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RatingBar(
                    glow: false,
                    initialRating: rating,
                    ignoreGestures: true,
                    onRatingUpdate: (value) => null,
                    ratingWidget: RatingWidget(
                      full: Image(
                        image: AssetImage('assets/heart.png'),
                      ),
                      half: Image(
                        image: AssetImage('assets/heart_half.png'),
                      ),
                      empty: Image(
                        image: AssetImage('assets/heart_border.png'),
                      ),
                    ),
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  ),
                ),
                Card(
                  color: Colors.green,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          Text(
                            "Comments",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          Expanded(
                            child: Text(
                              comments,
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ]),
                      )
                    ],
                  ),
                ),
                Card(
                  color: Colors.green,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          Text(
                            "Recipes",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FutureBuilder(
                          future: recipeRes,
                          builder: (BuildContext context,
                              AsyncSnapshot<Recipe> snapshot) {
                            // If there is a recipe for this meal
                            if (snapshot.hasData) {
                              return Column(children: [
                                ListTile(
                                  title: Text(
                                    "Ingredients",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    "Tap Icon to show",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.remove_red_eye_rounded,
                                      color: Colors.white,
                                    ),
                                    tooltip: 'Show Ingredients',
                                    onPressed: () {
                                      setState(() {
                                        showIngredients = !showIngredients;
                                      });
                                    },
                                  ),
                                ),
                                // if showIngredients is true, show ingredients table
                                showIngredients
                                    ? DataTable(
                                        // ingredient and amount columns
                                        columns: [
                                            DataColumn(
                                              label: Text(
                                                'Ingredient',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Amount',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        // dynamically create rows
                                        rows: snapshot
                                            .data.ingredientsRecipes.entries
                                            .map(
                                              (entry) =>
                                                  DataRow(cells: <DataCell>[
                                                DataCell(
                                                  Text(
                                                    entry.key,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    entry.value,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ]),
                                            )
                                            .toList())
                                    : Text(" "),
                                Column(children: [
                                  ListTile(
                                    title: Text(
                                      "Method",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0.0, 8.0, 0.0, 0.0),
                                      child: Text(
                                        '${snapshot.data.strInstructions}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Recipe Source",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0.0, 8.0, 0.0, 0.0),
                                        child: Text(
                                          snapshot.data.strSource,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      onTap: () =>
                                          launch(snapshot.data.strSource),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Video ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0.0, 8.0, 0.0, 0.0),
                                        child: Text(
                                          snapshot.data.strYoutube,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      onTap: () =>
                                          launch(snapshot.data.strYoutube),
                                    ),
                                  ),
                                ]),
                              ]);
                              // If there is an error with the request
                            } else if (snapshot.hasError) {
                              return ListTile(
                                title: Text(
                                  "Cannot fetch recipe for this meal!",
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                              // If there is not a meal found
                            } else {
                              // no recipes, return error
                              if (snapshot.data == null) {
                                return ListTile(
                                  title: Text(
                                    "Cannot fetch recipe for this meal!",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              }
                              // recipes are loading
                              return ListTile(
                                title: Text("Loading"),
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }

  /// Shows modal window for editing a particular rating with ratings and
  /// comments options
  _ratingEditBottomModal(BuildContext context, AppUser user) {
    FirestoreServce firestoreServce = FirestoreServce(uid: user.uid);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.65,
          child: BottomSheet(
            onClosing: () {},
            builder: (BuildContext context) {
              double _rating;
              String _comments;
              // stateful builder allows state local to the modal
              return StatefulBuilder(
                builder: (BuildContext context, setStateModal) => Container(
                  margin: EdgeInsets.all(30.0),
                  child: FormBuilder(
                    key: _formKey,
                    child: Column(children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Text(
                            "Rating",
                          ),
                        ),
                      ),
                      FormBuilderField(
                        name: "name",
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                        builder: (FormFieldState<dynamic> field) {
                          return InputDecorator(
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(top: 10.0, bottom: 0.0),
                              border: InputBorder.none,
                              errorText: field.errorText,
                            ),
                            child: RatingBar.builder(
                                initialRating: 0,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                onRatingUpdate: (value) =>
                                    setStateModal(() => _rating = value)),
                          );
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FormBuilderTextField(
                        decoration: const InputDecoration(
                            labelText: 'Update the comments',
                            icon: Icon(Icons.comment)),
                        name: "comments",
                        onChanged: (value) =>
                            setStateModal(() => _comments = value),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          onPressed: () async {
                            // Change the values under the modal if they have been updated
                            widget.detail.rating =
                                _rating ?? widget.detail.rating;
                            widget.detail.comments =
                                _comments ?? widget.detail.comments;

                            try {
                              await firestoreServce.updateRating(widget.detail);
                              setState(() {});
                              Navigator.pop(context);
                            } catch (Exception) {}
                          },
                          child: Text("Rate!",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ]),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Displays modal window for deleting a particular rating
  _ratingDeleteBottomModal(BuildContext context, AppUser user) {
    FirestoreServce firestoreServce = FirestoreServce(uid: user.uid);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.65,
          child: BottomSheet(
            onClosing: () {},
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (BuildContext context, setStateModal) => Container(
                  margin: EdgeInsets.all(30.0),
                  child: Column(children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text(
                          "Are you sure you want to delete this rating?",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        onPressed: () async {
                          try {
                            await firestoreServce.deleteRating(widget.detail);
                            // Pop views to get back to the ratings page
                            Navigator.pop(context);
                            Navigator.pop(context);
                          } catch (Exception) {}
                        },
                        child: Text("Yes, delete rating!",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ]),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
