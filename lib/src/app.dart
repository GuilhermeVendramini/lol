import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Screens
import 'package:lol/src/screens/login_screen.dart';
import 'package:lol/src/screens/user_profile_screen.dart';

// Controllers
import 'package:lol/src/controllers/user_controller.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserAuth>(
      builder: (_) => UserAuth(),
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

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.cyan[600],
        buttonColor: Colors.cyan[600],
      ),
      home: userAuth.isLogged != null ? UserProfileScreen() : LoginScreen(),
      routes: {
        '/profile': (BuildContext context) => UserProfileScreen(),
      },
    );
  }
}