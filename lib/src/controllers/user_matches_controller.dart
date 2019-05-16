import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lol/src/models/match_model.dart';
import 'package:lol/src/models/user_matches_model.dart';
import 'package:lol/src/controllers/api.dart';


class UserMatchesController with ChangeNotifier {
  UserMatchesModel _userMatches;
  bool _isMatchesLoaded;
}

class UserMatches extends UserMatchesController {
  UserMatchesModel get getUserMatches {
    return _userMatches;
  }

  bool get isMatchesLoaded {
    return _isMatchesLoaded;
  }
}

class UserMatchesService extends UserMatches {
  Future<Map<String, dynamic>> loadUserMatches(String accountId) async {

    if(_isMatchesLoaded != null) {
      return {'success': true, 'message': 'Loaded matches successfully'};
    }

    bool success = false;
    String message = 'Error load matches';
    http.Response response;

    response = await http.get(
      'https://na1.api.riotgames.com/lol/match/v4/matchlists/by-account/$accountId',
      headers: {
        'Accept-Charset': 'application/x-www-form-urlencoded; charset=UTF-8',
        'X-Riot-Token': '$API_KEY',
      },
    );

    final Map<String, dynamic> responseData = json.decode(response.body);

    if(responseData.containsKey('endIndex')) {
      success = true;
      message = 'Loaded matches successfully';

      final List<MatchModel> matches = [];
      List<dynamic> matchList = responseData['matches'];

      matchList.forEach((matchData){
          final MatchModel match = MatchModel(
            lane: matchData['lane'],
            gameId: matchData['gameId'],
            champion: matchData['champion'],
            platformId: matchData['platformId'],
            timestamp: matchData['timestamp'],
            queue: matchData['queue'],
            role: matchData['role'],
            season: matchData['season'],
          );
        matches.add(match);
      });

      _userMatches = UserMatchesModel(
        matches: matches,
        endIndex: responseData['endIndex'],
        startIndex: responseData['startIndex'],
        totalGames: responseData['totalGames'],
      );
      _isMatchesLoaded = true;
    }
    notifyListeners();
    return {'success': success, 'message': message};
  }
}