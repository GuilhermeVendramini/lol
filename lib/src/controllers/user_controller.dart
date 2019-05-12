import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:lol/src/models/user_model.dart';


class UserController {

  UserModel _authUser;

  UserModel get getUser {
    return _authUser;
  }

  Future<Map<String, dynamic>> auth(String userName) async {
    print('------------------------------ auth -----------------');
    final Map<String, dynamic> authData = {
      'userName': userName,
    };

    http.Response response;

    response = await http.post(
      'https://teste',
      body: json.encode(authData),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final Map<String, dynamic> responseData = json.decode(response.body);

    _authUser = UserModel(
      profileIconId: responseData['profileIconId'],
      name: responseData['name'],
      puuid: responseData['puuid'],
      summonerLevel: responseData['summonerLevel'],
      accountId: responseData['accountId'],
      id: responseData['id'],
      revisionDate: responseData['revisionDate'],
    );

    return null;
  }
}