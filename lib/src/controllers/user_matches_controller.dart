import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lol/src/models/match_model.dart';
import 'package:lol/src/models/user_matches_model.dart';
import 'package:lol/src/controllers/api.dart';


class UserMatchesController with ChangeNotifier {
  UserMatchesModel _userMatches;
  bool _isMatchesLoaded;
  Map<String, dynamic> _mostPlayedAt;
  List<dynamic> _playedAt;
  String _lastMatch;
}

class UserMatches extends UserMatchesController {
  UserMatchesModel get getUserMatches {
    return _userMatches;
  }

  bool get isMatchesLoaded {
    return _isMatchesLoaded;
  }

  Map<String, dynamic> get mostPlayedAt {
    return _mostPlayedAt;
  }

  List<dynamic> get playedAt {
    return _playedAt;
  }

  String get lastMatch {
    return _lastMatch;
  }

  void get clearMatchesValues {
    _userMatches = null;
    _isMatchesLoaded = null;
    _mostPlayedAt = null;
    _playedAt = null;
    _lastMatch = null;
    notifyListeners();
  }
}

class UserMatchesService extends UserMatches {
  Future<Map<String, dynamic>> loadUserMatches(String accountId) async {

    if(_isMatchesLoaded != null) {
      return {'success': true, 'message': 'Matches already loaded.'};
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

      // Most Played At
      List<Map<String, dynamic>> lanes = [];

      int countLaneJungle = matchList.take(10).where((match) => match['lane'] == 'JUNGLE').length;
      int countLaneTop = matchList.take(10).where((match) => match['lane'] == 'TOP').length;
      int countLaneNone = matchList.take(10).where((match) => match['lane'] == 'NONE').length;
      int countLaneMid = matchList.take(10).where((match) => match['lane'] == 'MID').length;
      int countLaneBottom = matchList.take(10).where((match) => match['lane'] == 'BOTTOM').length;

      lanes = [
        {'lane': 'JUNGLE', 'count': countLaneJungle},
        {'lane': 'TOP', 'count': countLaneTop},
        {'lane': 'NONE', 'count': countLaneNone},
        {'lane': 'MID', 'count': countLaneMid},
        {'lane': 'BOTTOM', 'count': countLaneBottom},
      ];

      _playedAt = lanes;

      lanes.sort((left, right) {
        return left['count'].compareTo(right['count']);
      });

      _mostPlayedAt = lanes.last;
      int lastMatch = 0;
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

        lastMatch = matchData['timestamp'] > lastMatch
            ? matchData['timestamp'] : lastMatch;
      });

      // Last Match
      DateTime date = DateTime.fromMillisecondsSinceEpoch(lastMatch);
      _lastMatch = DateFormat('dd/MM/yy').add_jm().format(date);

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