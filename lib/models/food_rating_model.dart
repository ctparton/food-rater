import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FoodRating {
  final String rName;
  final String rLocation;
  final String mealName;
  final String date;
  double rating;
  final String image;
  String comments;
  final String docID;
  final double latitude;
  final double longitude;
  final String cuisine;

  FoodRating(
      {this.rName,
      this.rLocation,
      this.mealName,
      this.date,
      this.rating,
      this.image,
      this.comments,
      this.docID,
      this.latitude,
      this.longitude,
      this.cuisine});

  @override
  String toString() => 'Restaurant: $rName, City: $rLocation, Rating; $rating)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is FoodRating && o.rName == rName && o.rLocation == rLocation;
  }

  dynamic getImage() {
    dynamic imagePlaceholder;
    try {
      imagePlaceholder = Image.network(image, fit: BoxFit.cover, errorBuilder:
          (BuildContext context, Object exception, StackTrace stackTrace) {
        return SvgPicture.asset('assets/043-ramen.svg');
      });
    } catch (Exception) {
      imagePlaceholder = SvgPicture.asset('assets/043-ramen.svg');
    }

    return imagePlaceholder;
  }

  @override
  int get hashCode => rName.hashCode ^ rLocation.hashCode;
}
