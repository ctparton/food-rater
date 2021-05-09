import 'package:flutter/material.dart';
import 'package:food_rater/models/recipe_model.dart';

/// Displays the fetched [AsyncSnapshot<Recipe>] ingredients and quantities,
/// formatted in a [DataTable] widget
class IngredientsDataTable extends StatelessWidget {
  const IngredientsDataTable(
      {Key key, @required AsyncSnapshot<Recipe> snapshot})
      : ingredients = snapshot,
        super(key: key);

  final AsyncSnapshot<Recipe> ingredients;

  @override
  Widget build(BuildContext context) {
    final Map<dynamic, dynamic> ingredientsQuantities =
        ingredients.data.ingredientsQuantities;
    return DataTable(
        // ingredient and amount columns
        columns: [
          DataColumn(
            label: Text(
              'Ingredient',
              style: TextStyle(color: Colors.white),
            ),
          ),
          DataColumn(
            label: Text(
              'Amount',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
        // dynamically create rows of ingredients with quantities
        rows: ingredientsQuantities.entries
            .map(
              (entry) => DataRow(cells: <DataCell>[
                DataCell(
                  Text(
                    entry.key,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                DataCell(
                  Text(
                    entry.value,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ]),
            )
            .toList());
  }
}
