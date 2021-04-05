import 'package:flutter/material.dart';
import 'package:food_rater/services/auth.dart';
import 'package:food_rater/views/common/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

// A class to show the settings page of the application
class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: Text("Sign Out"),
                leading: Icon(Icons.logout),
                onTap: () async {
                  await _auth.signOut();
                  Navigator.pop(context);
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text("About App"),
                leading: Icon(Icons.info),
                onTap: () => showAboutDialog(
                    context: context,
                    applicationName: "Food Mapr",
                    children: [
                      Text(
                          "Placeholder Icons made by 'https://www.flaticon.com/authors/flat-icons', Flat Icons from 'https://www.flaticon.com/'"),
                      Text(
                          "Avatar icons made by icons 8 'https://icons8.com/icon/pack/users/color--static'")
                    ]),
              ),
            ),
            Card(
              child: ListTile(
                  title: Text("Change Avatar"),
                  leading: Icon(Icons.face_retouching_natural),
                  onTap: () => displayAvatarSelection()),
            ),
            // Dark theme toggle
            Card(
              child: SwitchListTile(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  final provider =
                      Provider.of<ThemeProvider>(context, listen: false);
                  provider.switchTheme(value);
                },
                title: Text("Dark Theme"),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Creates the different avatar options that the user can select
  List<FormBuilderFieldOption<dynamic>> createFormOptions() {
    List<FormBuilderFieldOption<dynamic>> options = [];

    for (int i = 1; i < 11; i += 1) {
      const int TOTAL_VARIANTS = 5;
      String currentIcon =
          'icons8-user-${i < TOTAL_VARIANTS + 1 ? 'female' : 'male'}-skin-type-${i < TOTAL_VARIANTS + 1 ? i : i - TOTAL_VARIANTS}-48.png';

      options.add(FormBuilderFieldOption(
        value: currentIcon,
        child: Image.asset(
          'assets/$currentIcon',
          width: 48,
          height: 48,
        ),
      ));
    }

    return options;
  }

  /// Displays the dialog with the avatar selection
  Future<void> displayAvatarSelection() async {
    return await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          String selectedRadio = "test";
          return AlertDialog(
            title: Text('Choose an Avatar'),
            contentPadding: EdgeInsets.all(8.0),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FormBuilder(
                      child: Column(
                    children: [
                      FormBuilderChoiceChip(
                        runSpacing: 5.0,
                        spacing: 5.0,
                        onChanged: (value) => selectedRadio = value,
                        name: 'choice_chip',
                        options: createFormOptions(),
                      ),
                    ],
                  ))
                ],
              );
            }),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              FlatButton(
                onPressed: () async => {
                  Navigator.pop(context),
                  await _auth.updateAvatar(selectedRadio)
                },
                child: Text('Confirm'),
              ),
            ],
          );
        });
  }
}
