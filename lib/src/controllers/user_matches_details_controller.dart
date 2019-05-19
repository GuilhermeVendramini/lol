import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lol/src/models/user_matches_model.dart';
import 'package:lol/src/models/match_detail_model.dart';
import 'package:lol/src/controllers/api.dart';

class UserMatchesDetailsController with ChangeNotifier {
  List<MatchDetailModel> _userMatchesDetailsModel;
  bool _isMatchesDetailsLoaded;
}

class UserMatchesDetails extends UserMatchesDetailsController {
  List<MatchDetailModel> get getUserMatchesDetails {
    return _userMatchesDetailsModel;
  }

  bool get isMatchesDetailsLoaded {
    return _isMatchesDetailsLoaded;
  }
}

class UserMatchesDetailsService extends UserMatchesDetails {
  Future<Map<String, dynamic>> loadUserMatchesDetails(
      UserMatchesModel userMatches) async {

    if (_isMatchesDetailsLoaded != null) {
      return {'success': true, 'message': 'Matches details already loaded.'};
    }

    int error = 0;
    bool success = false;
    _isMatchesDetailsLoaded = true;
    _userMatchesDetailsModel = [];

    if (userMatches.matches != null) {
      userMatches.matches.take(10).forEach((matchData) async {
        http.Response response;
        response = await http.get(
          'https://na1.api.riotgames.com/lol/match/v4/matches/${matchData.gameId}',
          headers: {
            'Accept-Charset':
                'application/x-www-form-urlencoded; charset=UTF-8',
            'X-Riot-Token': '$API_KEY',
          },
        );

        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('gameId')) {
          success = true;
          final MatchDetailModel matchDetail = MatchDetailModel(
            seasonId: responseData['seasonId'],
            queueId: responseData['queueId'],
            gameId: responseData['gameId'],
            //participantIdentities: responseData['participantIdentities'],
            platformId: responseData['platformId'],
            gameMode: responseData['gameMode'],
            mapId: responseData['mapId'],
            gameType: responseData['gameType'],
            //teams: responseData[' platformId'],
            //participants: responseData[' platformId'],
            gameDuration: responseData['gameDuration'],
            gameCreation: responseData['gameCreation'],
          );
          _userMatchesDetailsModel.add(matchDetail);
          notifyListeners();
        } else {
          error++;
        }
      });
    }

    return {
      'success': success,
      'message': 'Matches details loaded with $error errors.'
    };
  }
}
