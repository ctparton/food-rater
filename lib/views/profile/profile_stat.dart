import 'package:flutter/material.dart';

/// A class to show a statistic on the users profile.
///
/// A statistics includes a [String] of statText to show a [String] userStat
/// with an [IconData] statIcon to the left
class ProfileStat extends StatelessWidget {
  const ProfileStat(
      {Key key,
      @required this.statText,
      @required this.userStat,
      @required this.statIcon})
      : super(key: key);
  final String statText;
  final dynamic userStat;
  final IconData statIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(statIcon),
        ),
        Expanded(
          child: Text(
            "$statText $userStat",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ]),
    );
  }
}
