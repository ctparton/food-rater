import 'dart:convert';

import 'package:http/http.dart';
import 'package:food_rater/models/recipe2.dart';

class RecipeService {
  final String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<Recipe2> getRecipe(String mealName) async {
    String encondedMealName = Uri.encodeComponent(mealName.trim());
    Response res = await get('$baseUrl/search.php?s=$encondedMealName');
    if (res.statusCode == 200) {
      print("request made");
      List<dynamic> body = jsonDecode(res.body)['meals'];

      if (body != null) {
        List<Recipe2> recipes =
            body.map((dynamic e) => Recipe2.fromMap(e)).toList();
        print("request content ${recipes[0].ingredientsRecipes}");
        return recipes[0];
      } else {
        return null;
      }
    } else {
      throw "Cannot get meal information";
    }
  }

  Future<String> getCuisine(String mealName) async {
    String encondedMealName = Uri.encodeComponent(mealName.trim());
    Response res = await get('$baseUrl/search.php?s=$encondedMealName');
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
