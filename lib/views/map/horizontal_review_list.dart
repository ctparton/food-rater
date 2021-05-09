import 'package:flutter/material.dart';
import 'package:food_rater/models/food_rating_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// A class to create the horizontal [List<FoodRating>], that sit on top of the
/// GoogleMap
class HorizontalReviewList extends StatelessWidget {
  const HorizontalReviewList({
    Key key,
    @required List<FoodRating> ratings,
    @required this.mapController,
  })  : _ratings = ratings,
        super(key: key);

  final List<FoodRating> _ratings;

  /// Map controller to allow onTap animation events on ratings
  final GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      // list takes up bottom 20% of the screen
      padding: EdgeInsets.fromLTRB(
          0, MediaQuery.of(context).size.height * 0.80, 0, 32),
      child: ListView.builder(
          itemExtent: 200,
          scrollDirection: Axis.horizontal,
          itemCount: _ratings.length,
          itemBuilder: (context, index) {
            return createHorizontalRatingCard(_ratings[index]);
          }),
    );
  }

  /// Creates the individual ratings card, which can be tapped to zoom the map
  /// to the restaurant
  Widget createHorizontalRatingCard(FoodRating rating) {
    return Card(
      color: Colors.green,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              rating.rName,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              '${rating.mealName} on ${rating.date}',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // If rating tapped, move Google map to this rating
              mapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(rating.latitude, rating.longitude),
                      zoom: 15.0),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
