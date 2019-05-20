import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lol/src/models/participants_model.dart';
import 'package:lol/src/models/participants_stats_model.dart';
import 'package:lol/src/models/player_model.dart';
import 'package:lol/src/models/team_model.dart';
import 'package:lol/src/models/user_matches_model.dart';
import 'package:lol/src/models/match_detail_model.dart';
import 'package:lol/src/controllers/api.dart';

class UserMatchesDetailsController with ChangeNotifier {
  List<MatchDetailModel> _userMatchesDetailsModel;
  bool _isMatchesDetailsLoaded;
  Map<String, dynamic> _userWinFail;
}

class UserMatchesDetails extends UserMatchesDetailsController {
  List<MatchDetailModel> get getUserMatchesDetails {
    _userMatchesDetailsModel.sort((MatchDetailModel a, MatchDetailModel b) {
      return b.timestamp.compareTo(a.timestamp);
    });
    return _userMatchesDetailsModel;
  }

  bool get isMatchesDetailsLoaded {
    return _isMatchesDetailsLoaded;
  }

  Map<String, dynamic> get userWinFail {
    return _userWinFail;
  }

  void get clearMatchesDetailsValues {
    _userMatchesDetailsModel = null;
    _isMatchesDetailsLoaded = null;
    _userWinFail = null;
    notifyListeners();
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
    int _win = 0, _fail = 0;

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

          final SharedPreferences prefs = await SharedPreferences.getInstance();
          Map<String, dynamic> mapUserParticipant;
          final accountId = prefs.getString('accountId');

          List<PlayerModel> participantIdList = [];
          responseData['participantIdentities'].forEach((participantIdData) {

            if(accountId == participantIdData['player']['accountId']) {
              mapUserParticipant = {
                'accountId': accountId,
                'participantId': participantIdData['participantId'],
              };
            }

            participantIdList.add(PlayerModel(
              participantId: participantIdData['participantId'],
              accountId: participantIdData['player']['accountId'],
              summonerName: participantIdData['player']['summonerName'],
            ));
          });

          List<TeamModel> teamsList = [];
          responseData['teams'].forEach((teamData) {
            teamsList.add(TeamModel(
              teamId: teamData['teamId'],
              win: teamData['win'],
            ));
          });

          ParticipantsStatsModel userStats;
          List<ParticipantsModel> participantsList = [];
          responseData['participants'].forEach((participantsData) {
            participantsList.add(ParticipantsModel(
              participantId: participantsData['participantId'],
              championId: participantsData['championId'],
              teamId: participantsData['teamId'],
              stats: ParticipantsStatsModel(
                assists: participantsData['stats']['assists'],
                deaths: participantsData['stats']['deaths'],
                doubleKills: participantsData['stats']['doubleKills'],
                kills: participantsData['stats']['kills'],
                pentaKills: participantsData['stats']['pentaKills'],
                quadraKills: participantsData['stats']['quadraKills'],
                tripleKills: participantsData['stats']['tripleKills'],
                win: participantsData['stats']['win']  == 'true' ? 1 : 0,
                champLevel: participantsData['stats']['champLevel'],
                teamWin: null,
              ),
            ));

            if(mapUserParticipant != null && mapUserParticipant['participantId'] == participantsData['participantId']) {
              Iterable<TeamModel> userTeam = teamsList.where((team) => team.teamId == participantsData['teamId']);
              userStats = ParticipantsStatsModel(
                assists: participantsData['stats']['assists'],
                deaths: participantsData['stats']['deaths'],
                doubleKills: participantsData['stats']['doubleKills'],
                kills: participantsData['stats']['kills'],
                pentaKills: participantsData['stats']['pentaKills'],
                quadraKills: participantsData['stats']['quadraKills'],
                tripleKills: participantsData['stats']['tripleKills'],
                win: participantsData['stats']['win']  == true ? 1 : 0,
                teamWin: userTeam.first.win,
                champLevel: participantsData['stats']['champLevel'],
              );

              userTeam.first.win == 'Win' ? _win++ : _fail++;
              int _total = _win + _fail;
              double _winComplete = _win / _total * 100;
              double _failComplete =  _fail / _total * 100;
              _userWinFail = {
                'win':_win,
                'fail': _fail,
                'winComplete': _winComplete,
                'failComplete': _failComplete,
                'winRemaining': 100 - _winComplete,
                'failRemaining': 100 - _failComplete,
              };
            }
          });

          final MatchDetailModel matchDetail = MatchDetailModel(
            seasonId: responseData['seasonId'],
            queueId: responseData['queueId'],
            gameId: responseData['gameId'],
            participantIdentities: participantIdList,
            platformId: responseData['platformId'],
            gameMode: responseData['gameMode'],
            mapId: responseData['mapId'],
            gameType: responseData['gameType'],
            teams: teamsList,
            participants: participantsList,
            gameDuration: responseData['gameDuration'],
            gameCreation: responseData['gameCreation'],
            userStats: userStats,
            timestamp: matchData.timestamp,
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
