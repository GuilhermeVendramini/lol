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

  void userLogout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('profileIconId');
    prefs.remove('name');
    prefs.remove('puuid');
    prefs.remove('summonerLevel');
    prefs.remove('accountId');
    prefs.remove('id');
    prefs.remove('revisionDate');
    prefs.remove('avatar');
    _isLogged = null;
    notifyListeners();
  }

  Future<bool> verifyLogged() async {
    // Get local User data
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('name') != null && prefs.getString('name').isNotEmpty) {

      final String userName = prefs.getString('name');
      http.Response response;

      response = await http.get(
        'https://na1.api.riotgames.com/lol/summoner/v4/summoners/by-name/$userName',
        headers: {
          'Accept-Charset': 'application/x-www-form-urlencoded; charset=UTF-8',
          'X-Riot-Token': '$API_KEY',
        },
      );

      final Map<String, dynamic> responseData = json.decode(response.body);

      _authUser = UserModel(
        profileIconId: prefs.getInt('profileIconId'),
        name: prefs.getString('name'),
        puuid: prefs.getString('puuid'),
        summonerLevel: responseData['summonerLevel'],
        accountId: prefs.getString('accountId'),
        id: prefs.getString('id'),
        revisionDate: responseData['revisionDate'],
        avatar: 'https://avatar.leagueoflegends.com/NA1/$userName.png',
      );
      _isLogged = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<Map<String, dynamic>> auth(String userName) async {
    if(_isLogged != null) {
      return {'success': true, 'message': 'Authenticated successfully'};
    }

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
        avatar: 'https://avatar.leagueoflegends.com/NA1/$userName.png',
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
      prefs.setString('avatar', 'https://avatar.leagueoflegends.com/NA1/$userName.png');
      notifyListeners();
    }

    return {'success': success, 'message': message};
  }
}
