import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

/// Creates the heart ratings bar, which is read-only and set to the current
/// rating of the meal passed in with the [double] rating
class StaticRatingsBar extends StatelessWidget {
  const StaticRatingsBar({
    Key key,
    @required this.rating,
  }) : super(key: key);

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RatingBar(
        glow: false,
        initialRating: rating,
        // Creates read-only behaviour
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
    );
  }
}
