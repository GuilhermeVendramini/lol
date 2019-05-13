import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lol/src/controllers/user_controller.dart';

class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final user = Provider.of<UserAuth>(context);
    return Scaffold(
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: targetWidth,
              child: Text(user.getUser.name),
            ),
          ),
        ),
      ),
    );
  }

}