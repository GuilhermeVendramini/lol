import 'package:flutter/material.dart';
import 'package:lol/src/controllers/campions_controller.dart';
import 'package:lol/src/controllers/user_champions_controller.dart';
import 'package:lol/src/controllers/user_controller.dart';
import 'package:lol/src/controllers/user_matches_controller.dart';
import 'package:lol/src/controllers/user_matches_details_controller.dart';
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
    'userRegion': 'na1',
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 650.0 ? 600.0 : deviceWidth * 0.95;
    final userAuth = Provider.of<UserAuth>(context);

    if (userAuth.isLogged == null) {
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
    } else {
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
                      // _languageDropDownButton(),
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
  }

  DecorationImage _backgroundImage() {
    return DecorationImage(
      fit: BoxFit.cover,
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
      image: AssetImage('assets/images/background.jpg'),
    );
  }

  Widget _lolLogo() {
    return Image(
      fit: BoxFit.contain,
      height: 200.0,
      image: AssetImage('assets/images/lol-profile.png'),
    );
  }

  Widget _userNameTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'LoL Summoner',
        filled: true,
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'LoL Summoner  is required';
        }
      },
      onSaved: (String value) {
        _formData['userName'] = value;
      },
    );
  }

  Map<String, String> region = {'value': 'na1', 'label': 'North America'};
  List<Map<String, String>> regionItems = [
    {'value': 'br1', 'label': 'Brazil'},
    {'value': 'eun1', 'label': 'EU Nordic and East'},
    {'value': 'euw1', 'label': 'EU West'},
    {'value': 'jp1', 'label': 'Japan'},
    {'value': 'la1', 'label': 'Latinoamérica Norte'},
    {'value': 'la2', 'label': 'Latinoamérica Sul'},
    {'value': 'na1', 'label': 'North America'},
    {'value': 'na', 'label': 'North America (old)'},
    {'value': 'oc1', 'label': 'Oceania'},
    {'value': 'ru', 'label': 'Russia'},
    {'value': 'tr1', 'label': 'Turkey'},
  ];

  Widget _regionDropDownButton() {
    return DropdownButton<String>(
      value: region['value'],
      onChanged: (String newRegional) {
        setState(() {
          region['value'] = newRegional;
          _formData['userRegion'] = newRegional;
        });
      },
      items:
          regionItems.map<DropdownMenuItem<String>>((Map<String, String> item) {
        return DropdownMenuItem<String>(
          value: item['value'],
          child: Text(item['label']),
        );
      }).toList(),
    );
  }

/*  String languageValue = 'English';

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
  }*/

  void _submitForm(UserAuth userAuth, BuildContext context) async {
    _formKey.currentState.save();
    Map<String, dynamic> successInformation;
    successInformation =
        await userAuth.auth(_formData['userName'], _formData['userRegion']);

    if (successInformation['success']) {
      // Clear all provider to the next user
      final champions = Provider.of<ChampionsService>(context);
      final userMatches = Provider.of<UserMatchesService>(context);
      final userMatchesDetails =
          Provider.of<UserMatchesDetailsService>(context);
      final userChampions = Provider.of<UserChampionsService>(context);

      champions.clearChampionsValues;
      userMatchesDetails.clearMatchesDetailsValues;
      userMatches.clearMatchesValues;
      userChampions.clearUserChampionsValues;
      Navigator.pushReplacementNamed(context, '/profile');
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login'),
              content: Text(successInformation['message']),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }
}
