import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:food_rater/models/recipe_model.dart';

/// Displays the detail of the recipe including the method and source links
class RecipeDetail extends StatelessWidget {
  const RecipeDetail({Key key, @required AsyncSnapshot<Recipe> snapshot})
      : recipeDetail = snapshot,
        super(key: key);

  final AsyncSnapshot<Recipe> recipeDetail;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        title: Text(
          "Method",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
          child: Text(
            '${recipeDetail.data.strInstructions}',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      ListTile(
        title: Text(
          "Recipe Source",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: InkWell(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
            child: Text(
              recipeDetail.data.strSource,
              style: TextStyle(color: Colors.white),
            ),
          ),
          onTap: () => launch(recipeDetail.data.strSource),
        ),
      ),
      ListTile(
        title: Text(
          "Video ",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: InkWell(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
            child: Text(
              recipeDetail.data.strYoutube,
              style: TextStyle(color: Colors.white),
            ),
          ),
          onTap: () => launch(recipeDetail.data.strYoutube),
        ),
      ),
    ]);
  }
}
