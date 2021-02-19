import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class FoodRating {
  final String rName;
  final String rCity;
  final double rating;
  final String image;

  FoodRating({this.rName, this.rCity, this.rating, this.image});

  FoodRating copyWith({
    String rName,
    String rCity,
  }) {
    return FoodRating(
        rName: rName ?? this.rName,
        rCity: rCity ?? this.rCity,
        rating: rating ?? this.rating);
  }

  Map<String, dynamic> toMap() {
    return {
      'rName': rName,
      'rCity': rCity,
    };
  }

  factory FoodRating.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return FoodRating(
      rName: map['rName'],
      rCity: map['rCity'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FoodRating.fromJson(String source) =>
      FoodRating.fromMap(json.decode(source));

  // factory FoodRating.fromSnapshot(QuerySnapshot snapshot) {

  // }
  @override
  String toString() => 'Restaurant: $rName, City: $rCity, Rating; $rating)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is FoodRating && o.rName == rName && o.rCity == rCity;
  }

  dynamic getImage() {
    dynamic imagePlaceholder = image != null
        ? Image.network(image, fit: BoxFit.cover, errorBuilder:
            (BuildContext context, Object exception, StackTrace stackTrace) {
            return Text('Your error widget...');
          })
        : SvgPicture.asset('assets/043-ramen.svg');
    return imagePlaceholder;
  }

  @override
  int get hashCode => rName.hashCode ^ rCity.hashCode;
}
