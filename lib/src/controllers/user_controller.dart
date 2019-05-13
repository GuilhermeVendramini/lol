import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lol/src/models/user_model.dart';
import 'package:lol/src/controllers/api.dart';

class UserController with ChangeNotifier {
  UserModel _authUser;
  bool _isLogged;
}

class User extends UserController {
  UserModel get getUser {
    return _authUser;
  }

  bool get isLogged {
    return _isLogged;
  }
}

class UserAuth extends User {

  Future<bool> verifyLogged() async {
    // Get local User data
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('name') != null && prefs.getString('name').isNotEmpty) {
      _authUser = UserModel(
        profileIconId: prefs.getInt('profileIconId'),
        name: prefs.getString('name'),
        puuid: prefs.getString('puuid'),
        summonerLevel: prefs.getInt('summonerLevel'),
        accountId: prefs.getString('accountId'),
        id: prefs.getString('id'),
        revisionDate: prefs.getInt('revisionDate'),
      );
      print('----------------aquiii---------');
      _isLogged = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<Map<String, dynamic>> auth(String userName) async {
    bool success = false;
    String message = 'Invalid Username';
    http.Response response;

    response = await http.get(
      'https://na1.api.riotgames.com/lol/summoner/v4/summoners/by-name/$userName',
      headers: {
        'Accept-Charset': 'application/x-www-form-urlencoded; charset=UTF-8',
        'X-Riot-Token': '$API_KEY',
      },
    );

    final Map<String, dynamic> responseData = json.decode(response.body);

    if(responseData.containsKey('accountId')) {
      success = true;
      message = 'Authenticated successfully';

      _authUser = UserModel(
        profileIconId: responseData['profileIconId'],
        name: responseData['name'],
        puuid: responseData['puuid'],
        summonerLevel: responseData['summonerLevel'],
        accountId: responseData['accountId'],
        id: responseData['id'],
        revisionDate: responseData['revisionDate'],
      );

      // Set local User data
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('profileIconId', _authUser.profileIconId);
      prefs.setString('name', _authUser.name);
      prefs.setString('puuid', _authUser.puuid);
      prefs.setInt('summonerLevel', _authUser.summonerLevel);
      prefs.setString('accountId', _authUser.accountId);
      prefs.setString('id', _authUser.id);
      prefs.setInt('revisionDate', _authUser.revisionDate);
      notifyListeners();
    }

    return {'success': success, 'message': message};
  }
}
