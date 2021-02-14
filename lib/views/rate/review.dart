// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_rater/services/firestoreService.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:food_rater/models/appuser.dart';
// import 'dart:html';
// import 'dart:async';
import 'dart:io';

class Review extends StatefulWidget {
  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  final _formKey = GlobalKey<FormBuilderState>();
  File _image;
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AppUser>(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.all(30.0),
                child: FormBuilder(
                    key: _formKey,
                    child: Column(children: [
                      FormBuilderTextField(
                        name: "rName",
                        decoration: const InputDecoration(
                          icon: Icon(Icons.place),
                          labelText: 'Restaurant Name *',
                        ),
                      ),
                      FormBuilderTextField(
                        name: "rCity",
                        decoration: const InputDecoration(
                          icon: Icon(Icons.place),
                          labelText: 'City *',
                        ),
                      ),
                      FormBuilderTextField(
                        name: "mealName",
                        decoration: const InputDecoration(
                          icon: Icon(Icons.set_meal),
                          labelText: 'Meal Name *',
                        ),
                      ),
                      FormBuilderDateTimePicker(
                        name: 'date',
                        // onChanged: _onChanged,
                        inputType: InputType.date,
                        decoration: InputDecoration(
                            labelText: 'Consumed On',
                            icon: Icon(Icons.date_range)),
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
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                          );
                        },
                      ),
                      FormBuilderImagePicker(
                        name: 'photos',
                        imageQuality: 50,
                        onChanged: (value) {
                          print("value is $value");
                          if (value != null) {
                            print(value.first.runtimeType);
                            print(value.first);
                            setState(() {
                              _image = value.first;
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
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                        onPressed: () async {
                          print("image is $_image");
                          FirestoreServce firestoreServce =
                              FirestoreServce(uid: _user.uid);
                          await firestoreServce.addRating("test", "test");
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('Rating submitted'),
                            action: SnackBarAction(
                              label: 'View',
                              onPressed: () {
                                // Some code to undo the change.
                              },
                            ),
                          ));
                        },
                        child: Text("Rate!"),
                      )
                    ])))));
  }
}
