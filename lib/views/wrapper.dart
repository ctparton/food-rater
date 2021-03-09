import 'package:flutter/material.dart';
import 'package:food_rater/models/app_user_model.dart';
import 'package:food_rater/views/signin/signin.dart';
import 'package:provider/provider.dart';
import 'home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<AppUser>(context);

    if (_user == null) {
      return SignIn();
    } else {
      return Home();
    }
  }
}
