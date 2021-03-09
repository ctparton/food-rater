import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_rater/services/firestore_service.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:food_rater/models/app_user_model.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:food_rater/services/recipe_service.dart';
import 'package:food_rater/services/auth.dart';
import 'package:uuid/uuid.dart';
import 'package:food_rater/services/google_location_service.dart';

class Review extends StatefulWidget {
  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  final RecipeService recipeService = RecipeService();
  final _formKey = GlobalKey<FormBuilderState>();
  final AuthService _auth = AuthService();
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
      _formKey.currentState.reset();
      FocusScope.of(context).unfocus();
    });
  }

  _onChanged(value) {
    setState(() => _rName = value);
    bool newSession = false;
    if (_sessionToken == null) {
      newSession = true;
      setState(() {
        _sessionToken = uuid.v4();
      });
    }

    if (!newSession) {
      getSuggestion(value);
    }
  }

  _handleMealChange(value) {
    _mealName = value;
    _placeList = [];
  }

  void getSuggestion(String input) async {
    print("getting suggestons $input");
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
                dynamic result = await _auth.signOut();
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
                          decoration: const InputDecoration(
                            icon: Icon(Icons.place),
                            labelText: 'Restaurant Name *',
                          ),
                          onChanged: (value) => _onChanged(value)),
                      placeResultList(),
                      FormBuilderTextField(
                          autofocus: false,
                          name: "mealName",
                          decoration: const InputDecoration(
                            icon: Icon(Icons.set_meal),
                            labelText: 'Meal Name *',
                          ),
                          onChanged: (value) => _handleMealChange(value)),
                      FormBuilderDateTimePicker(
                        autofocus: false,
                        name: 'date',
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
                        name: "name",
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                        builder: (FormFieldState<dynamic> field) {
                          return InputDecorator(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              errorText: field.errorText,
                            ),
                            child: RatingBar.builder(
                                initialRating: 3,
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
                        imageQuality: 50,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            print(value.first);
                            setState(() {
                              _image = value.first;
                            });
                          } else {
                            print("Clearing");
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
                      RaisedButton(
                        onPressed: () async {
                          _rLocation = _rName;
                          _rName = _rName.split(",")[0];

                          FirestoreServce firestoreServce =
                              FirestoreServce(uid: _user.uid);
                          try {
                            dynamic cuisine;
                            try {
                              cuisine =
                                  await recipeService.getCuisine(_mealName);
                            } catch (err) {
                              print("Error $err");
                            }

                            dynamic result = await firestoreServce.addRating(
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
                              resetForm();
                            });
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('Rating submitted'),
                              action: SnackBarAction(
                                label: 'View',
                                onPressed: () {
                                  // Some code to undo the change.
                                },
                              ),
                            ));
                          } catch (err) {
                            print("Error $err");
                          }
                        },
                        child: Text("Rate!"),
                      )
                    ])))));
  }

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
