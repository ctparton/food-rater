import 'package:flutter/material.dart';
import 'package:food_rater/services/auth.dart';
import 'package:food_rater/views/common/theme_provider.dart';
import 'package:food_rater/views/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

/// Loads environment variables and starts up firebase service
void main() async {
  await DotEnv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

/// Application root which provides the current user and the dark or light
/// theme to the descendent widgets (e.g. all other views in the app) through
/// a MultiProvider.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Provider array for providing the theme and authentication status
      providers: [
        StreamProvider.value(value: AuthService().user),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
          builder: (context, child) {
            final themeProvider = Provider.of<ThemeProvider>(context);
            return MaterialApp(
              themeMode: themeProvider.themeMode,
              theme: CustomThemes.lightTheme,
              darkTheme: CustomThemes.darkTheme,
              home: Wrapper(),
            );
          },
        )
      ],
    );
  }
}
