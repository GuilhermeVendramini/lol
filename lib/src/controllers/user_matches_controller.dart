import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lol/src/controllers/api.dart';
import 'package:lol/src/models/match_model.dart';
import 'package:lol/src/models/user_matches_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserMatchesController with ChangeNotifier {
  UserMatchesModel _userMatches;
  bool _isMatchesLoaded;
  List<dynamic> _playedAt;
  Map<String, dynamic> _resultMessage;
}

class UserMatches extends UserMatchesController {
  UserMatchesModel get getUserMatches {
    return _userMatches;
  }

  bool get isMatchesLoaded {
    return _isMatchesLoaded;
  }

  List<dynamic> get playedAt {
    return _playedAt;
  }

  Map<String, dynamic> get resultMessage {
    return _resultMessage;
  }

  void get clearMatchesValues {
    _userMatches = null;
    _isMatchesLoaded = null;
    _playedAt = null;
    _resultMessage = null;
    notifyListeners();
  }
}

class UserMatchesService extends UserMatches {
  loadUserMatches(String accountId) async {
    if (_isMatchesLoaded != null) {
      _resultMessage = {'success': true, 'message': 'Matches already loaded.'};
      return null;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userRegion = prefs.getString('userRegion');

    http.Response response;
    response = await http.get(
      'https://$userRegion.api.riotgames.com/lol/match/v4/matchlists/by-account/$accountId',
      headers: {
        'Accept-Charset': 'application/x-www-form-urlencoded; charset=UTF-8',
        'X-Riot-Token': '$API_KEY',
      },
    ).catchError((onError) {
      _resultMessage = {
        'success': false,
        'message':
            'Was not possible to connect with the Server. Please try again in an hour.'
      };
    });

    if (response == null) {
      notifyListeners();
      return null;
    } else if (response.statusCode != 200 && response.statusCode != 201) {
      _resultMessage = {
        'success': false,
        'message': 'Was not possible load the matches. Please try again later.'
      };
      notifyListeners();
      return null;
    }

    final Map<String, dynamic> responseData = json.decode(response.body);

    if (responseData.containsKey('endIndex')) {
      final List<MatchModel> matches = [];
      List<dynamic> matchList = responseData['matches'];

      // Most Played At
      List<Map<String, dynamic>> lanes = [];

      int countLaneJungle =
          matchList.take(10).where((match) => match['lane'] == 'JUNGLE').length;
      int countLaneTop =
          matchList.take(10).where((match) => match['lane'] == 'TOP').length;
      int countLaneNone =
          matchList.take(10).where((match) => match['lane'] == 'NONE').length;
      int countLaneMid =
          matchList.take(10).where((match) => match['lane'] == 'MID').length;
      int countLaneBottom =
          matchList.take(10).where((match) => match['lane'] == 'BOTTOM').length;

      lanes = [
        {'lane': 'JUNGLE', 'count': countLaneJungle},
        {'lane': 'TOP', 'count': countLaneTop},
        {'lane': 'NONE', 'count': countLaneNone},
        {'lane': 'MID', 'count': countLaneMid},
        {'lane': 'BOTTOM', 'count': countLaneBottom},
      ];

      _playedAt = lanes;

      int lastMatch = 0;
      matchList.forEach((matchData) {
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

        lastMatch = matchData['timestamp'] > lastMatch
            ? matchData['timestamp']
            : lastMatch;
      });

      _userMatches = UserMatchesModel(
        matches: matches,
        endIndex: responseData['endIndex'],
        startIndex: responseData['startIndex'],
        totalGames: responseData['totalGames'],
      );
      _isMatchesLoaded = true;
      _resultMessage = {
        'success': true,
        'message': 'Loaded matches successfully.'
      };
    }
    notifyListeners();
    return null;
  }
}
