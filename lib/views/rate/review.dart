import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_rater/models/anim_type.dart';
import 'package:food_rater/services/firestore_service.dart';
import 'package:food_rater/views/common/loading_spinner.dart';
import 'package:food_rater/views/common/custom_app_bar.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:food_rater/models/app_user_model.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:food_rater/services/google_location_service.dart';

/// A class to build the form allowing a user to review a particular food and
/// save this data to Firestore.
class Review extends StatefulWidget {
  @override
  _ReviewState createState() => _ReviewState();
}

/// A class to hold the state of the form and handle submission actions.
class _ReviewState extends State<Review> {
  /// Key to hold the current state of the form
  final _formKey = GlobalKey<FormBuilderState>();

  // Form state holders
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

  /// If the [value] of the restaurant name field changes call the Google Places
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

    // get suggestions for current session
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

  /// Client method to upload the rating made to Firestore, the [uid] refers
  /// to the users uid to instantiate the [FireStoreService]
  void uploadRating(
      String uid,
      String _rName,
      String _rLocation,
      String _placeID,
      String _mealName,
      String date,
      double _rating,
      File _image,
      String _comments) async {
    setState(() => isLoading = true);
    _rLocation = _rName;
    // Get the name of the restaurant from the address
    _rName = _rName.split(",")[0];

    final FirestoreServce firestoreServce = FirestoreServce(uid: uid);
    try {
      // Upload the rating
      await firestoreServce.addRating(_rName, _rLocation, _placeID, _mealName,
          date, _rating, _image, _comments);
      setState(() {
        isLoading = false;
        resetForm();
      });
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Rating submitted'),
          action: SnackBarAction(
            label: 'View',
            onPressed: () {},
          ),
        ),
      );
      // Catch and display error
    } catch (err) {
      setState(() {
        isLoading = false;
        errorMessage = "An error has occured making the rating";
      });
    }
  }

  /// Builds the form elements including the rate button
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AppUser>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: FoodMaprAppBar(),
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
                onChanged: (value) => _onRestaurantNameChange(value),
              ),
              // UI placeholder for the autocomplete suggestions
              placeResultList(),
              FormBuilderTextField(
                autofocus: false,
                name: "mealName",
                validator: FormBuilderValidators.required(context),
                decoration: const InputDecoration(
                  icon: Icon(Icons.set_meal),
                  labelText: 'Meal Name *',
                ),
                onChanged: (value) => _onMealNameChange(value),
              ),
              // Date picker
              FormBuilderDateTimePicker(
                autofocus: false,
                name: 'date',
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                ]),
                inputType: InputType.date,
                decoration: InputDecoration(
                  labelText: 'Consumed On',
                  icon: Icon(Icons.date_range),
                ),
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
                ),
              ),
              // Custom form field to hold the rating slider
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
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (value) =>
                          setState(() => _rating = value),
                    ),
                  );
                },
              ),
              // Camera upload form
              FormBuilderImagePicker(
                name: 'photos',
                // compress photos for saving on server
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
                decoration: const InputDecoration(labelText: 'Pick Photos'),
                maxImages: 1,
              ),
              const SizedBox(height: 15),
              FormBuilderTextField(
                decoration: const InputDecoration(
                  labelText: 'Comments',
                  icon: Icon(Icons.comment),
                ),
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
                    // if form passes validation checks, attempt upload
                    if (_formKey.currentState.validate()) {
                      uploadRating(
                          _user.uid,
                          _rName,
                          _rLocation,
                          _placeID,
                          _mealName,
                          DateFormat('dd-MM-yyyy').format(_date),
                          _rating,
                          _image,
                          _comments);
                    }
                  },
                  child: Text(
                    "Rate!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // loading or error after rating submission
              isLoading
                  ? Container(
                      width: 300,
                      height: 300,
                      margin: EdgeInsets.all(40),
                      padding: EdgeInsets.only(bottom: 24),
                      alignment: Alignment.center,
                      child: LoadingSpinner(animationType: AnimType.rating),
                    )
                  : Text(
                      errorMessage,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    )
            ]),
          ),
        ),
      ),
    );
  }

  /// Builds a tile for each returned prediction from the Google Places API
  Widget placeResultList() {
    return Container(
      child: ListView.builder(
        // cannot scroll the suggestions
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _placeList.length,
        itemBuilder: (context, index) {
          return ListTile(
            // description is in the form placeName, city, country
            title: Text(_placeList[index]["description"]),
            onTap: () {
              dynamic place = _placeList[index];
              setState(() {
                // clear suggestions once an item has been tapped
                _placeList = [];
                _sessionToken = null;
                // get the placeID for future calls
                _placeID = place['place_id'];
              });
              // programatically override the restaurant name field with the current description
              _formKey.currentState.fields['rName']
                  .didChange(place["description"]);
            },
          );
        },
      ),
    );
  }
}
