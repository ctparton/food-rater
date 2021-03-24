import 'package:flutter/material.dart';
import 'package:food_rater/services/auth.dart';
import 'package:food_rater/views/common/theme_provider.dart';
import 'package:provider/provider.dart';

// A class to show the settigns page of the application
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
                onTap: () => showLicensePage(
                    context: context, applicationName: "Food Mapr"),
              ),
            ),
            // Dark theme toggle
            SwitchListTile(
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                final provider =
                    Provider.of<ThemeProvider>(context, listen: false);
                provider.switchTheme(value);
              },
              title: Text("Dark Theme"),
            )
          ],
        ),
      ),
    );
  }
}
