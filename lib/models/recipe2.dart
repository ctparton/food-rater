import 'dart:convert';

class Recipe2 {
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
  Recipe2(
      {this.idMeal,
      this.strMeal,
      this.strCategory,
      this.strArea,
      this.strInstructions,
      this.strMealThumb,
      this.strTags,
      this.strYoutube,
      this.ingredientsRecipes,
      this.strSource
      // this.strIngredient1,
      // this.strIngredient2,
      // this.strIngredient3,
      // this.strIngredient4,
      // this.strIngredient5,
      // this.strIngredient6,
      // this.strIngredient7,
      // this.strIngredient8,
      // this.strIngredient9,
      // this.strIngredient10,
      // this.strIngredient11,
      // this.strIngredient12,
      // this.strIngredient13,
      // this.strIngredient14,
      // this.strIngredient15,
      // this.strIngredient16,
      // this.strIngredient17,
      // this.strIngredient18,
      // this.strIngredient19,
      // this.strIngredient20,
      // this.strMeasure1,
      // this.strMeasure2,
      // this.strMeasure3,
      // this.strMeasure4,
      // this.strMeasure5,
      // this.strMeasure6,
      // this.strMeasure7,
      // this.strMeasure8,
      // this.strMeasure9,
      // this.strMeasure10,
      // this.strMeasure11,
      // this.strMeasure12,
      // this.strMeasure13,
      // this.strMeasure14,
      // this.strMeasure15,
      // this.strMeasure16,
      // this.strMeasure17,
      // this.strMeasure18,
      // this.strMeasure19,
      // this.strMeasure20,
      // this.strSource,
      // this.strImageSource,
      // this.strCreativeCommonsConfirmed,
      // this.dateModified,
      });

  factory Recipe2.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Recipe2(
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
    final test = {
      for (var a = 1; a < 21; a += 1)
        map['strIngredient$a']: map['strMeasure$a']
    };
    return test;
  }

  factory Recipe2.fromJson(String source) =>
      Recipe2.fromMap(json.decode(source));
}
