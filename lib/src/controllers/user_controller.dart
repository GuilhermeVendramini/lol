import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lol/src/models/user_model.dart';

class UserController with ChangeNotifier {
  UserModel _authUser;
}

class User extends UserController {
  UserModel get getUser {
    return _authUser;
  }
}

class UserAuth extends User {
  Future<Map<String, dynamic>> auth(String userName) async {
    http.Response response;
    response = await http.get(
      'https://na1.api.riotgames.com/lol/summoner/v4/summoners/by-name/$userName',
      headers: {
        'Accept-Charset': 'application/x-www-form-urlencoded; charset=UTF-8',
        'X-Riot-Token': 'RGAPI-c626a81e-63bd-472b-8186-4f0404ab144b',
      },
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData);

    bool hasError = true;
    String message = 'Invalid Username';

    if(responseData.containsKey('accountId')) {
      hasError = false;
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
      notifyListeners();
    }

    return {'success': !hasError, 'message': message};
  }
}
