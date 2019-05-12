import 'package:flutter/material.dart';
import 'package:lol/src/screens/login_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.cyan[600],
        buttonColor: Colors.cyan[600],
      ),
      home: LoginScreen(),
    );
  }
}