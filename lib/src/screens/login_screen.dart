import 'package:flutter/material.dart';
import 'package:lol/src/controllers/user_controller.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final Map<String, dynamic> _formData = {
    'userName': null,
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final userAuth = Provider.of<UserAuth>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: _backgroundImage(),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: targetWidth,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _lolLogo(),
                    SizedBox(
                      height: 40.0,
                    ),
                    _userNameTextField(),
                    SizedBox(
                      height: 40.0,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 60.0,
                      child: RaisedButton(
                        child: Text('SIGN IN'),
                        onPressed: () => _submitForm(userAuth, context),
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  DecorationImage _backgroundImage() {
    return DecorationImage(
      fit: BoxFit.cover,
      colorFilter: ColorFilter.mode(
          Colors.white.withOpacity(0.2),
          BlendMode.dstATop
      ),
      image: AssetImage('assets/images/background.jpg'),
    );
  }

  Widget _lolLogo() {
    return Image(
      fit: BoxFit.contain,
      image: AssetImage('assets/images/lol-logo.png'),
    );
  }

  Widget _userNameTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Username',
          filled: true,
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Username  is required';
        }
      },
      onSaved: (String value) {
        _formData['userName'] = value;
      },
    );
  }

  void _submitForm(UserAuth userAuth, BuildContext context) async {
    _formKey.currentState.save();
    Map<String, dynamic> successInformation;
    successInformation = await userAuth.auth(_formData['userName']);

    if(successInformation['success']) {
      Navigator.pushReplacementNamed(context, '/profile');
    } else {
      showDialog(context: context, builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login'),
          content: Text(successInformation['message']),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
    }
  }

}