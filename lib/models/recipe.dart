import 'dart:convert';

class Recipe {
  final String idMeal;
  final String strMeal;
  final String strCategory;
  final String strArea;
  final String strInstructions;
  final String strMealThumb;
  final String strTags;
  final String strYoutube;
  final String strSource;
  final String dateModified;
  Recipe({
    this.idMeal,
    this.strMeal,
    this.strCategory,
    this.strArea,
    this.strInstructions,
    this.strMealThumb,
    this.strTags,
    this.strYoutube,
    this.strSource,
    this.dateModified,
  });

  Recipe copyWith({
    String idMeal,
    String strMeal,
    String strCategory,
    String strArea,
    String strInstructions,
    String strMealThumb,
    String strTags,
    String strYoutube,
    String strSource,
    String dateModified,
  }) {
    return Recipe(
      idMeal: idMeal ?? this.idMeal,
      strMeal: strMeal ?? this.strMeal,
      strCategory: strCategory ?? this.strCategory,
      strArea: strArea ?? this.strArea,
      strInstructions: strInstructions ?? this.strInstructions,
      strMealThumb: strMealThumb ?? this.strMealThumb,
      strTags: strTags ?? this.strTags,
      strYoutube: strYoutube ?? this.strYoutube,
      strSource: strSource ?? this.strSource,
      dateModified: dateModified ?? this.dateModified,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idMeal': idMeal,
      'strMeal': strMeal,
      'strCategory': strCategory,
      'strArea': strArea,
      'strInstructions': strInstructions,
      'strMealThumb': strMealThumb,
      'strTags': strTags,
      'strYoutube': strYoutube,
      'strSource': strSource,
      'dateModified': dateModified,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Recipe(
      idMeal: map['idMeal'],
      strMeal: map['strMeal'],
      strCategory: map['strCategory'],
      strArea: map['strArea'],
      strInstructions: map['strInstructions'],
      strMealThumb: map['strMealThumb'],
      strTags: map['strTags'],
      strYoutube: map['strYoutube'],
      strSource: map['strSource'],
      dateModified: map['dateModified'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Recipe.fromJson(String source) => Recipe.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Recipe(idMeal: $idMeal, strMeal: $strMeal, strCategory: $strCategory, strArea: $strArea, strInstructions: $strInstructions, strMealThumb: $strMealThumb, strTags: $strTags, strYoutube: $strYoutube, strSource: $strSource, dateModified: $dateModified)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Recipe &&
        o.idMeal == idMeal &&
        o.strMeal == strMeal &&
        o.strCategory == strCategory &&
        o.strArea == strArea &&
        o.strInstructions == strInstructions &&
        o.strMealThumb == strMealThumb &&
        o.strTags == strTags &&
        o.strYoutube == strYoutube &&
        o.strSource == strSource &&
        o.dateModified == dateModified;
  }

  @override
  int get hashCode {
    return idMeal.hashCode ^
        strMeal.hashCode ^
        strCategory.hashCode ^
        strArea.hashCode ^
        strInstructions.hashCode ^
        strMealThumb.hashCode ^
        strTags.hashCode ^
        strYoutube.hashCode ^
        strSource.hashCode ^
        dateModified.hashCode;
  }
}
