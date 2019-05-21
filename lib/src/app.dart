import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

// Screens
import 'package:lol/src/screens/login_screen.dart';
import 'package:lol/src/screens/base_screen.dart';
import 'package:lol/src/screens/settings_screen.dart';

// Controllers
import 'package:lol/src/controllers/user_controller.dart';
import 'package:lol/src/controllers/user_matches_controller.dart';
import 'package:lol/src/controllers/user_matches_details_controller.dart';

import 'controllers/campions_controller.dart';
import 'controllers/user_champions_controller.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserAuth>(builder: (_) => UserAuth()),
        ChangeNotifierProvider<UserMatchesService>(builder: (_) => UserMatchesService()),
        ChangeNotifierProvider<ChampionsService>(builder: (_) => ChampionsService()),
        ChangeNotifierProvider<UserMatchesDetailsService>(builder: (_) => UserMatchesDetailsService()),
        ChangeNotifierProvider<UserChampionsService>(builder: (_) => UserChampionsService()),
      ],
      child:  RunMaterialApp(),
    );
  }
}

class RunMaterialApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RunMaterialAppState();
  }
}

class _RunMaterialAppState extends State<RunMaterialApp> {
  @override
  Widget build(BuildContext context) {
    final userAuth = Provider.of<UserAuth>(context);

    if(userAuth.isLogged == null) {
      userAuth.verifyLogged();
    }

    return DynamicTheme(
        defaultBrightness: Brightness.dark,
        data: (brightness) => new ThemeData(
          appBarTheme: AppBarTheme(color: Colors.cyan[600]),
          accentColor: Colors.cyan[600],
          buttonColor: Colors.cyan[600],
          cursorColor: Colors.cyan[600],
          inputDecorationTheme: InputDecorationTheme(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.cyan[600],),
              ),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.cyan[600],)),
              labelStyle: TextStyle(color: Colors.cyan[600])
          ),
          brightness: brightness,
        ),
        themedWidgetBuilder: (context, theme) {
          return new MaterialApp(
            title: 'Lol Profile',
            theme: theme,
            home: userAuth.isLogged != null && userAuth.isLogged ? BaseScreen() : LoginScreen(),
            routes: {
              '/profile': (BuildContext context) => BaseScreen(),
              '/settings': (BuildContext context) => SettingsScreen(),
            },
          );
        }
    );
  }
}