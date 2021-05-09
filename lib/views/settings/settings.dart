import 'package:flutter/material.dart';
import 'package:food_rater/services/auth.dart';
import 'package:food_rater/views/common/theme_provider.dart';
import 'package:food_rater/views/settings/settings_tile.dart';
import 'package:provider/provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/// A class to display the various settings options in the application.
class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

/// Holds the state of the currently selected settings
class _SettingsScreenState extends State<SettingsScreen> {
  /// instance of the Firebase AuthService to handle sign out and user pref updates
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormBuilderState>();

  /// Displays an about dialog modal to view license info
  void showAppInfo() {
    return showAboutDialog(
        context: context,
        applicationName: "Food Mapr",
        children: [
          Text(
              "Placeholder Icons made by 'https://www.flaticon.com/authors/flat-icons', Flat Icons from 'https://www.flaticon.com/'"),
          Text(
              "Avatar icons made by icons 8 'https://icons8.com/icon/pack/users/color--static'")
        ]);
  }

  /// Client method to sign user out and return to sign in page
  void signOutUser() async {
    await _auth.signOut();
    Navigator.pop(context);
  }

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
            GenericSettingsTile(
              settingName: "Sign Out",
              settingsAction: () => signOutUser(),
              settingsIcon: Icons.exit_to_app,
            ),
            // full list of packages used, also noted in pubspec.yaml
            GenericSettingsTile(
              settingName: "About App",
              settingsAction: () => showAppInfo(),
              settingsIcon: Icons.info,
            ),
            GenericSettingsTile(
              settingName: "Change Avatar",
              settingsAction: () => displayAvatarSelection(),
              settingsIcon: Icons.face_retouching_natural,
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
    const int TOTAL_AVATARS = 11;
    List<FormBuilderFieldOption<dynamic>> options = [];

    for (int i = 1; i < TOTAL_AVATARS; i += 1) {
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
          String selectedAvatar = "";
          return AlertDialog(
            title: Text('Choose an Avatar'),
            contentPadding: EdgeInsets.all(8.0),
            // stateful builder allows local state within the dialog to change selection
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FormBuilder(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Chip input for avatar selection
                        FormBuilderChoiceChip(
                          runSpacing: 5.0,
                          spacing: 5.0,
                          onChanged: (value) => selectedAvatar = value,
                          name: 'avatar_choice_chip',
                          options: createFormOptions(),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                          ]),
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
                  if (_formKey.currentState.validate())
                    {
                      Navigator.pop(context),
                      await _auth.updateAvatar(selectedAvatar)
                    }
                },
                child: Text('Confirm'),
              ),
            ],
          );
        });
  }
}
