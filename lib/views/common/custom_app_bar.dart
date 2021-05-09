import 'package:flutter/material.dart';
import 'package:food_rater/views/settings/settings.dart';

/// A class to hold the custom AppBar for the FoodMapr application.
///
/// This is re-used in the profile and review screen
class FoodMaprAppBar extends StatelessWidget {
  const FoodMaprAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("FoodMapr"),
      actions: [
        IconButton(
          icon: Icon(
            Icons.settings,
            color: Colors.white,
          ),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsScreen(),
              ),
            );
          },
        )
      ],
    );
  }
}
