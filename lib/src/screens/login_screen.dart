import 'package:flutter/material.dart';
import 'package:lol/src/controllers/user_controller.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenSate();
  }
}

class _LoginScreenSate extends State<LoginScreen> {
  final Map<String, dynamic> _formData = {
    'userName': null,
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 650.0 ? 600.0 : deviceWidth * 0.95;
    final userAuth = Provider.of<UserAuth>(context);

    if(userAuth.isLogged == null) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: _backgroundImage(),
          ),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

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
                      height: 30.0,
                    ),
                    Text('Region/Language'),
                    _regionDropDownButton(),
                    _languageDropDownButton(),
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
          Colors.black.withOpacity(0.2),
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