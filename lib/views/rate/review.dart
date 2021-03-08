import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_rater/services/firestoreService.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:food_rater/models/appuser.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:food_rater/services/recipe_service.dart';
import 'package:food_rater/services/auth.dart';

class Review extends StatefulWidget {
  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  final RecipeService recipeService = RecipeService();
  final _formKey = GlobalKey<FormBuilderState>();
  final AuthService _auth = AuthService();

  String _rName;
  String _rCity;
  String _mealName;
  dynamic _date;
  double _rating;
  File _image;
  String _comments;

  void resetForm() {
    print("resetting form");
    setState(() {
      _rName = '';
      _rCity = '';
      _mealName = '';
      _date = '';
      _rating = 1;
      _image = null;
      _comments = '';
      _formKey.currentState.reset();
      FocusScope.of(context).unfocus();
    });
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
                        onChanged: (value) => setState(() => _rName = value),
                      ),
                      FormBuilderTextField(
                          autofocus: false,
                          name: "rCity",
                          decoration: const InputDecoration(
                            icon: Icon(Icons.place),
                            labelText: 'City *',
                          ),
                          onChanged: (value) => setState(() => _rCity = value)),
                      FormBuilderTextField(
                          autofocus: false,
                          name: "mealName",
                          decoration: const InputDecoration(
                            icon: Icon(Icons.set_meal),
                            labelText: 'Meal Name *',
                          ),
                          onChanged: (value) =>
                              setState(() => _mealName = value)),
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
                              // icon: Icon(Icons.rate_review),
                              // labelText: "Rating",
                              // contentPadding:
                              //     EdgeInsets.only(top: 10.0, bottom: 0.0),
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
                        onSaved: (value) => print("In saved called $value"),
                        onImage: (value) => print("on image called $value"),
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
                          print("Restaurant is $_rName");
                          print("City is $_rCity");
                          print("Meal is $_mealName");
                          print(
                              "Date is ${DateFormat('dd-MM-yyyy').format(_date)}");
                          print("Rating is $_rating");
                          print("image is $_image");
                          print("comments are $_comments");
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
                                _rCity,
                                _mealName,
                                DateFormat('dd-MM-yyyy').format(_date),
                                _rating,
                                _image,
                                _comments,
                                cuisine);
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
}
