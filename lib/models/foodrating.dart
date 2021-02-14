import 'dart:convert';

class FoodRating {
  final String rName;
  final String city;
  FoodRating({
    this.rName,
    this.city,
  });

  FoodRating copyWith({
    String rName,
    String city,
  }) {
    return FoodRating(
      rName: rName ?? this.rName,
      city: city ?? this.city,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rName': rName,
      'city': city,
    };
  }

  factory FoodRating.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return FoodRating(
      rName: map['rName'],
      city: map['city'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FoodRating.fromJson(String source) =>
      FoodRating.fromMap(json.decode(source));

  @override
  String toString() => 'FoodRating(rName: $rName, city: $city)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is FoodRating && o.rName == rName && o.city == city;
  }

  @override
  int get hashCode => rName.hashCode ^ city.hashCode;
}
