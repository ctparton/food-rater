import 'package:flutter/material.dart';
import 'package:food_rater/services/auth.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
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
              ),
            ),
            SwitchListTile(
              value: false,
              onChanged: null,
              title: Text("Dark Theme"),
            )
          ],
        ),
      ),
    );
  }
}
