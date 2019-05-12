import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: _backgroundImage(),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: targetWidth,
              child: Column(
                children: <Widget>[
                  _lolLogo(),
                  SizedBox(
                    height: 40.0,
                  ),
                  _emailTextField(),
                  SizedBox(
                    height: 30.0,
                  ),
                  _passwordTextField(),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text('Region/Language'),
                  _regionDropDownButton(),
                  _languageDropDownButton(),
                  SizedBox(
                    height: 30.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 60.0,
                    child: RaisedButton(
                      child: Text('SIGN IN'),
                      onPressed: () => {},
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

  Widget _emailTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Username',
          filled: true,
      ),
      onSaved: (String value) {},
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Password',
          filled: true,
      ),
      obscureText: true,
      onSaved: (String value) {},
    );
  }

  String regionValue = 'North America';

  Widget _regionDropDownButton() {
    return DropdownButton<String>(
      value: regionValue,
      onChanged: (String newValue) {
        setState(() {
          regionValue = newValue;
        });
      },
      items: <String>[
        'North America',
        'Brazil',
        'Japan',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  String languageValue = 'English';

  Widget _languageDropDownButton() {
    return DropdownButton<String>(
      value: languageValue,
      onChanged: (String newValue) {
        setState(() {
          languageValue = newValue;
        });
      },
      items: <String>[
        'English',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}