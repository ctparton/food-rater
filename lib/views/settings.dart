import 'package:flutter/material.dart';
import 'package:food_rater/services/auth.dart';
import 'package:food_rater/views/common/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/// A class to show the various settings of the application
class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

/// Holds the state of the currently selected settings
class _SettingsScreenState extends State<SettingsScreen> {
  /// instance of the Firebase AuthService to handle sign out and user pref updates
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    // the current theme, which may be togggled
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      // Creates a scrolling list of settings cards
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
                onTap: () => displayAvatarSelection(),
              ),
            ),
            // Dark theme toggle
            Card(
              child: SwitchListTile(
                // if dark mode is currently active, switch toggle to on state, else switch off.
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

  /// Creates the different avatar options that the user can choose from
  List<FormBuilderFieldOption<dynamic>> createFormOptions() {
    const int TOTAL_VARIANTS = 5;
    List<FormBuilderFieldOption<dynamic>> options = [];

    for (int i = 1; i < 11; i += 1) {
      String currentIcon =
          'icons8-user-${i < TOTAL_VARIANTS + 1 ? 'female' : 'male'}-skin-type-${i < TOTAL_VARIANTS + 1 ? i : i - TOTAL_VARIANTS}-48.png';

      // add a form option for each of the generated icons
      options.add(
        FormBuilderFieldOption(
          value: currentIcon,
          child: Image.asset(
            'assets/$currentIcon',
            width: 48,
            height: 48,
          ),
        ),
      );
    }

    return options;
  }

  /// Displays the dialog with all possible avatar selections
  Future<void> displayAvatarSelection() async {
    return await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          String selectedRadio = "no radio";
          return AlertDialog(
            title: Text('Choose an Avatar'),
            contentPadding: EdgeInsets.all(8.0),
            // stateful builder allows local state within the dialog
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FormBuilder(
                    child: Column(
                      children: [
                        // Chip input for avatar selection
                        FormBuilderChoiceChip(
                          runSpacing: 5.0,
                          spacing: 5.0,
                          onChanged: (value) => selectedRadio = value,
                          name: 'avatar_choice_chip',
                          options: createFormOptions(),
                        ),
                      ],
                    ),
                  ),
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
