import 'package:flutter/material.dart';

/// Displays a settings tile consisting of a settingName [String], settingIcon
/// [IconData] and a [Function] to run when the setting is tapped
class GenericSettingsTile extends StatelessWidget {
  const GenericSettingsTile({
    Key key,
    @required this.settingName,
    @required this.settingsIcon,
    @required this.settingsAction,
  }) : super(key: key);
  final String settingName;
  final IconData settingsIcon;
  final Function settingsAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          title: Text(settingName),
          leading: Icon(settingsIcon),
          onTap: settingsAction),
    );
  }
}
