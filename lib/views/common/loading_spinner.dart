import 'package:flutter/material.dart';
import 'package:food_rater/models/anim_type.dart';
import 'package:food_rater/views/common/theme_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LoadingSpinner extends StatefulWidget {
  final AnimType animationType;

  LoadingSpinner({this.animationType});

  @override
  _LoadingSpinnerState createState() => _LoadingSpinnerState();
}

class _LoadingSpinnerState extends State<LoadingSpinner> {
  String lottieFile;
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
        color: themeProvider.isDarkMode ? Colors.black : Colors.white,
        child: Center(child: Lottie.asset(lottieFile)));
  }
}
