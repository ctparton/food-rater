import 'dart:convert';
import 'package:http/http.dart';
import 'package:food_rater/models/recipe_model.dart';

/// Service class to handle all requests to the MealDB API
///
/// source: https://www.themealdb.com/api.php
class RecipeService {
  final String BASE_URL = 'https://www.themealdb.com/api/json/v1/1';

  /// Attempts to get a recipe with the name [mealName], Returns a [Recipe] if
  /// successful, else returns null
  Future<Recipe> getRecipe(String mealName) async {
    // Encodes the mealName for use in request
    String encondedMealName = Uri.encodeComponent(mealName.trim());
    Response res = await get('$BASE_URL/search.php?s=$encondedMealName');
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body)['meals'];

      if (body != null) {
        List<Recipe> recipes =
            body.map((dynamic e) => Recipe.fromMap(e)).toList();
        // return the top predicted recipe for the meal
        return recipes[0];
      } else {
        return null;
      }
    } else {
      throw "Cannot get meal information";
    }
  }

  /// Attempts to get the cuisine of the [mealName], Returns a [String] of the
  /// cuisine type if successful, else returns null
  Future<String> getCuisine(String mealName) async {
    String encondedMealName = Uri.encodeComponent(mealName.trim());
    Response res = await get('$BASE_URL/search.php?s=$encondedMealName');
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body)['meals'];
      if (body != null) {
        return body[0]['strArea'];
      } else {
        return null;
      }
    } else {
      throw "Cannot fetch cuisine information";
    }
  }
}
