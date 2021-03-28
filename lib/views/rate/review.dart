import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_rater/models/anim_type.dart';
import 'package:food_rater/services/firestore_service.dart';
import 'package:food_rater/views/common/loading_spinner.dart';
import 'package:food_rater/views/settings.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:food_rater/models/app_user_model.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:food_rater/services/recipe_service.dart';
import 'package:uuid/uuid.dart';
import 'package:food_rater/services/google_location_service.dart';

/// A class to build the form allowing a user to review a particular food and
/// save this data to Firestore.
class Review extends StatefulWidget {
  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  final RecipeService recipeService = RecipeService();
  final _formKey = GlobalKey<FormBuilderState>();
  String errorMessage = "";
  String _placeID;
  var uuid = new Uuid();
  String _sessionToken;
  List<dynamic> _placeList = [];
  String _rName;
  String _rLocation;
  String _mealName;
  dynamic _date;
  double _rating;
  File _image;
  String _comments;
  bool isLoading = false;

  // resets the form and the state
  void resetForm() {
    print("resetting form");
    setState(() {
      _rName = '';
      _rLocation = '';
      _mealName = '';
      _date = '';
      _rating = 1;
      _image = null;
      _comments = '';
      _placeID = null;
      _sessionToken = null;
      // Clears the form
      _formKey.currentState.reset();
      // Unfocuses the keyboard
      FocusScope.of(context).unfocus();
    });
  }

  /// If the value of the restaurant name field changes call the Google Places
  /// Autocomplete API
  _onRestaurantNameChange(value) {
    setState(() => _rName = value);
    bool newSession = false;
    if (_sessionToken == null) {
      // Create a new session token
      newSession = true;
      setState(() {
        _sessionToken = uuid.v4();
      });
    }

    if (!newSession) {
      getSuggestion(value);
    }
  }

  /// Sets the meal name to current value and clears the places Autocomplete
  _onMealNameChange(value) {
    _mealName = value;
    _placeList = [];
  }

  /// Makes the actual call to Google places and sets the [_placeList] with the response
  void getSuggestion(String input) async {
    try {
      List<dynamic> res = await GoogleLocationService()
          .getPlaceAutocomplete(input, _sessionToken);
      setState(() {
        _placeList = res;
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AppUser>(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
        body: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Container(
                margin: EdgeInsets.all(30.0),
                child: FormBuilder(
                    key: _formKey,
                    child: Column(children: [
                      FormBuilderTextField(
                          autofocus: false,
                          name: "rName",
                          validator: FormBuilderValidators.required(context),
                          decoration: const InputDecoration(
                            icon: Icon(Icons.place),
                            labelText: 'Restaurant Name *',
                          ),
                          onChanged: (value) => _onRestaurantNameChange(value)),
                      placeResultList(),
                      FormBuilderTextField(
                          autofocus: false,
                          name: "mealName",
                          validator: FormBuilderValidators.required(context),
                          decoration: const InputDecoration(
                            icon: Icon(Icons.set_meal),
                            labelText: 'Meal Name *',
                          ),
                          onChanged: (value) => _onMealNameChange(value)),
                      FormBuilderDateTimePicker(
                        autofocus: false,
                        name: 'date',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                        inputType: InputType.date,
                        decoration: InputDecoration(
                            labelText: 'Consumed On',
                            icon: Icon(Icons.date_range)),
                        onChanged: (value) => setState(() => _date = value),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Text(
                              "Rating",
                            ),
                          )),
                      FormBuilderField(
                        name: "rating",
                        builder: (FormFieldState<dynamic> field) {
                          return InputDecorator(
                            decoration: InputDecoration(
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
                                    setState(() => _rating = value)),
                          );
                        },
                      ),
                      FormBuilderImagePicker(
                        name: 'photos',
                        imageQuality: 60,
                        iconColor: Colors.blue,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              _image = value.first;
                            });
                          } else {
                            setState(() {
                              _image = null;
                            });
                          }
                        },
                        decoration:
                            const InputDecoration(labelText: 'Pick Photos'),
                        maxImages: 1,
                      ),
                      const SizedBox(height: 15),
                      FormBuilderTextField(
                        decoration: const InputDecoration(
                            labelText: 'Comments', icon: Icon(Icons.comment)),
                        name: "comments",
                        onChanged: (value) => setState(() => _comments = value),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          onPressed: () async {
                            _formKey.currentState.save();
                            if (_formKey.currentState.validate()) {
                              setState(() => isLoading = true);
                              _rLocation = _rName;
                              // Get the name of the restaurant from the address
                              _rName = _rName.split(",")[0];

                              FirestoreServce firestoreServce =
                                  FirestoreServce(uid: _user.uid);
                              try {
                                String cuisine;
                                try {
                                  cuisine =
                                      await recipeService.getCuisine(_mealName);
                                } catch (err) {
                                  cuisine = null;
                                }

                                await firestoreServce.addRating(
                                  _rName,
                                  _rLocation,
                                  _placeID,
                                  _mealName,
                                  DateFormat('dd-MM-yyyy').format(_date),
                                  _rating,
                                  _image,
                                  _comments,
                                  cuisine,
                                );
                                setState(() {
                                  isLoading = false;
                                  resetForm();
                                });
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Rating submitted'),
                                  action: SnackBarAction(
                                    label: 'View',
                                    onPressed: () {},
                                  ),
                                ));
                              } catch (err) {
                                setState(() {
                                  isLoading = false;
                                  errorMessage =
                                      "An error has occured making the rating";
                                });
                              }
                            }
                          },
                          child: Text("Rate!",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      isLoading
                          ? Container(
                              width: 300,
                              height: 300,
                              margin: EdgeInsets.all(40),
                              padding: EdgeInsets.only(bottom: 24),
                              alignment: Alignment.center,
                              child: LoadingSpinner(
                                  animationType: AnimType.rating))
                          : Text(errorMessage,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red))
                    ])))));
  }

  /// Builds a tile for each returned prediction from the Google Places API
  Widget placeResultList() {
    return Container(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _placeList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_placeList[index]["description"]),
            onTap: () {
              dynamic place = _placeList[index];
              setState(() {
                _placeList = [];
                _sessionToken = null;
                _placeID = place['place_id'];
              });
              _formKey.currentState.fields['rName']
                  .didChange(place["description"]);
            },
          );
        },
      ),
    );
  }
}
