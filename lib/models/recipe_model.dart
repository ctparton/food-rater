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
  static Map<dynamic, dynamic> buildIngredientsMap(map) {
    final foodIngredientsMap = {
      for (var a = 1; a < 21; a += 1)
        map['strIngredient$a']: map['strMeasure$a']
    };
    return foodIngredientsMap;
  }

  factory Recipe.fromJson(String source) => Recipe.fromMap(json.decode(source));
}
