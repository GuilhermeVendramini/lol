import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lol/src/screens/login_screen.dart';
import 'package:lol/src/screens/user_profile_screen.dart';
import 'package:lol/src/controllers/user_controller.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserAuth>(
      builder: (_) => UserAuth(),
      child:       MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness: Brightness.dark,
          accentColor: Colors.cyan[600],
          buttonColor: Colors.cyan[600],
        ),
        home: LoginScreen(),
        routes: {
          '/profile':  (BuildContext context) => UserProfileScreen(),
        },
      ),
    );
  }
}