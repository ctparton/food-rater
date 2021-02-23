import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_rater/models/foodrating.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:food_rater/models/appuser.dart';
import 'package:food_rater/services/firestoreService.dart';

class RatingsDetail extends StatefulWidget {
  final FoodRating detail;

  RatingsDetail({this.detail});

  @override
  _RatingsDetailState createState() => _RatingsDetailState();
}

class _RatingsDetailState extends State<RatingsDetail> {
  double rating;
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AppUser>(context);
    rating = widget.detail.rating;
    return Scaffold(
      body: Center(
        child: CustomScrollView(
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
                    onPressed: () => _ratingEditBottomModal(context, _user)),
                IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _ratingDeleteBottomModal(context, _user))
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.detail.mealName,
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold)),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Consumed on: ${widget.detail.date}",
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.w300))),
                Container(
                    height: 100,
                    child: Card(
                      color: Colors.green,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(children: [Text("Rating")]),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RatingBar(
                                initialRating: rating,
                                ignoreGestures: true,
                                onRatingUpdate: (value) => null,
                                ratingWidget: RatingWidget(
                                  full: Image(
                                      image: AssetImage('assets/heart.png')),
                                  half: Image(
                                      image:
                                          AssetImage('assets/heart_half.png')),
                                  empty: Image(
                                      image: AssetImage(
                                          'assets/heart_border.png')),
                                ),
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0)),
                          ),
                        ],
                      ),
                    )),
                Card(
                  color: Colors.green,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [Text("Comments")]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          Expanded(child: Text(widget.detail.comments))
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
                        child: Row(children: [Text("Recipes")]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("fetch recipes here"),
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

  _ratingEditBottomModal(BuildContext context, AppUser user) {
    FirestoreServce firestoreServce = FirestoreServce(uid: user.uid);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.40,
          child: BottomSheet(
            onClosing: () {},
            builder: (BuildContext context) {
              final _formKey = GlobalKey<FormBuilderState>();
              double _rating;
              String _comments;
              bool b = false;
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
                          )),
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
                                    setStateModal(() => _rating = value)),
                          );
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                        onPressed: () async {
                          widget.detail.rating = _rating;
                          print("Rating is $_rating");
                          try {
                            await firestoreServce.updateRating(widget.detail);
                            setState(() => rating = widget.detail.rating);
                          } catch (Exception) {
                            print("failed");
                          }
                        },
                        child: Text("Rate!"),
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

  _ratingDeleteBottomModal(BuildContext context, AppUser user) {
    FirestoreServce firestoreServce = FirestoreServce(uid: user.uid);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.40,
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
                            "Rating",
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      onPressed: () async {
                        try {
                          await firestoreServce.deleteRating(widget.detail);
                        } catch (Exception) {
                          print("failed");
                        }
                      },
                      child: Text("Delete Rating!"),
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
