import 'dart:convert';

/// A model for serialization of recipes retrieved from the MealDB API
/// source: https://www.themealdb.com/api.php
class Recipe {
  final String idMeal;
  final String strMeal;
  final String strCategory;
  final String strArea;
  final String strInstructions;
  final String strMealThumb;
  final String strTags;
  final String strYoutube;
  final Map ingredientsRecipes;
  final String strSource;

  Recipe(
      {this.idMeal,
      this.strMeal,
      this.strCategory,
      this.strArea,
      this.strInstructions,
      this.strMealThumb,
      this.strTags,
      this.strYoutube,
      this.ingredientsRecipes,
      this.strSource});

  /// Decodes a single Recipe json response into a Recipe object.
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
        ingredientsRecipes: buildIngredientsMap(map),
        strSource: map['strSource']);
  }

  // Returns a map of all the ingredients in the response.
  static Map<dynamic, dynamic> buildIngredientsMap(map) {
    // Each recipe has ingredients from ingredient 1 up to 21 ingredients.
    final foodIngredientsMap = {
      for (var a = 1; a < 21; a += 1)
        map['strIngredient$a']: map['strMeasure$a']
    };
    return foodIngredientsMap;
  }

  /// Helper method to do response decoding.
  factory Recipe.fromJson(String source) => Recipe.fromMap(json.decode(source));
}
