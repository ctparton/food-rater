import 'package:flutter/material.dart';
import 'package:food_rater/models/anim_type.dart';
import 'package:food_rater/views/common/theme_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

/// Provides re-usable loading widgets to the app with various [animationType]
/// This includes animations upon sign-in and when creating a rating.
class LoadingSpinner extends StatefulWidget {
  final AnimType animationType;

  LoadingSpinner({this.animationType});

  @override
  _LoadingSpinnerState createState() => _LoadingSpinnerState();
}

class _LoadingSpinnerState extends State<LoadingSpinner> {
  String lottieFile;

  /// Displays the appropriate [LottieAnimation] depending on the [animationType]
  /// which is themed as appropriate
  @override
  Widget build(BuildContext context) {
    switch (widget.animationType) {
      case AnimType.loading:
        lottieFile = "assets/loading.json";
        break;
      case AnimType.rating:
        lottieFile = "assets/food_loading.json";
        break;
      default:
        throw Exception("Could not find enum");
        break;
    }
    // gets the light or dark theme that the app is currently using
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      color: themeProvider.isDarkMode ? Colors.grey.shade900 : Colors.white,
      child: Center(
        child: Lottie.asset(lottieFile),
      ),
    );
  }
}
