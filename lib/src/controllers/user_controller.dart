import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lol/src/controllers/api.dart';
import 'package:lol/src/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController with ChangeNotifier {
  UserModel _authUser;
  bool _isLogged;
  String _levelUserImage;
}

class User extends UserController {
  UserModel get getUser {
    return _authUser;
  }

  bool get isLogged {
    return _isLogged;
  }

  String get levelUserImage {
    return _levelUserImage;
  }
}

class UserAuth extends User {
  void userLogout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userRgion');
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
    if (prefs.getString('name') != null && prefs.getString('name').isNotEmpty) {
      final String userName = prefs.getString('name');
      http.Response response;

      response = await http.get(
        'https://na1.api.riotgames.com/lol/summoner/v4/summoners/by-name/$userName',
        headers: {
          'Accept-Charset': 'application/x-www-form-urlencoded; charset=UTF-8',
          'X-Riot-Token': '$API_KEY',
        },
      ).catchError((onError) {
        userLogout();
      });

      if (response == null ||
          (response.statusCode != 200 && response.statusCode != 201)) {
        userLogout();
        return false;
      }

      final Map<String, dynamic> responseData = json.decode(response.body);

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

      _levelUserImage = 'assets/images/level-5.png';
      if (responseData['summonerLevel'] != null &&
          responseData['summonerLevel'] < 5) {
        _levelUserImage =
            'assets/images/level-${responseData['summonerLevel']}.png';
      }

      _isLogged = true;
      notifyListeners();
      return true;
    }
    _isLogged = false;
    notifyListeners();
    return false;
  }

  Future<Map<String, dynamic>> auth(String userName, String userRegion) async {
    if (_isLogged != null && _isLogged) {
      return {'success': true, 'message': 'Authenticated successfully'};
    }

    bool success = false;
    String message = 'Invalid LoL Summoner';
    http.Response response;

    response = await http.get(
      'https://$userRegion.api.riotgames.com/lol/summoner/v4/summoners/by-name/$userName',
      headers: {
        'Accept-Charset': 'application/x-www-form-urlencoded; charset=UTF-8',
        'X-Riot-Token': '$API_KEY',
      },
    ).catchError((onError) {
      message =
          'Was not possible to connect. Please check your connection and try again.';
    });

    if (response == null) {
      return {'success': success, 'message': message};
    }

    switch (response.statusCode) {
      case 403:
      case 404:
        {
          message =
              'Was not possible to connect with the Server. Please try again in an hour.';
        }
        break;
    }

    final Map<String, dynamic> responseData = json.decode(response.body);

    if (responseData.containsKey('accountId')) {
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

      _levelUserImage = 'assets/images/level-5.png';
      if (responseData['summonerLevel'] < 5) {
        _levelUserImage =
            'assets/images/level-${responseData['summonerLevel']}.png';
      }

      // Set local User data
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userRegion', userRegion);
      prefs.setInt('profileIconId', _authUser.profileIconId);
      prefs.setString('name', _authUser.name);
      prefs.setString('puuid', _authUser.puuid);
      prefs.setInt('summonerLevel', _authUser.summonerLevel);
      prefs.setString('accountId', _authUser.accountId);
      prefs.setString('id', _authUser.id);
      prefs.setInt('revisionDate', _authUser.revisionDate);
      prefs.setString(
          'avatar', 'https://avatar.leagueoflegends.com/NA1/$userName.png');
      notifyListeners();
    }

    return {'success': success, 'message': message};
  }
}
