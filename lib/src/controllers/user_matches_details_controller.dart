import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lol/src/controllers/api.dart';
import 'package:lol/src/models/match_detail_model.dart';
import 'package:lol/src/models/participants_model.dart';
import 'package:lol/src/models/participants_stats_model.dart';
import 'package:lol/src/models/player_model.dart';
import 'package:lol/src/models/team_model.dart';
import 'package:lol/src/models/user_matches_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserMatchesDetailsController with ChangeNotifier {
  List<MatchDetailModel> _userMatchesDetailsModel;
  Iterable<MatchDetailModel> _userMatchDetails;
  List<dynamic> _killSequence = [];
  List<dynamic> _performance = [];
  List<dynamic> _goldEarned = [];
  Map<String, dynamic> _resultMessage;
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

  MatchDetailModel getMatch(int matchId) {
    _userMatchDetails =
        _userMatchesDetailsModel.where((match) => match.gameId == matchId);
    return _userMatchDetails.first;
  }

  bool get isMatchesDetailsLoaded {
    return _isMatchesDetailsLoaded;
  }

  Map<String, dynamic> get userWinFail {
    return _userWinFail;
  }

  List<dynamic> get killSequence {
    return _killSequence;
  }

  List<dynamic> get performance {
    return _performance;
  }

  List<dynamic> get goldEarned {
    _goldEarned.sort((a, b) {
      return b['matchTime'].compareTo(a['matchTime']);
    });
    return _goldEarned;
  }

  Map<String, dynamic> get resultMessage {
    return _resultMessage;
  }

  void get clearMatchesDetailsValues {
    _userMatchesDetailsModel = null;
    _isMatchesDetailsLoaded = null;
    _userWinFail = null;
    _resultMessage = null;
    _killSequence = [];
    _performance = [];
    _goldEarned = [];
    notifyListeners();
  }
}

class UserMatchesDetailsService extends UserMatchesDetails {
  loadUserMatchesDetails(UserMatchesModel userMatches) async {
    if (_isMatchesDetailsLoaded != null) {
      _resultMessage = {
        'success': true,
        'message': 'Matches details already loaded.'
      };
      return null;
    }

    _isMatchesDetailsLoaded = false;
    _userMatchesDetailsModel = [];
    int _win = 0, _fail = 0;
    int _countDoubleKills = 0;
    int _countTripleKills = 0;
    int _countQuadraKills = 0;
    int _countPentaKills = 0;
    int _countKills = 0;
    int _countDeaths = 0;
    int _countAssists = 0;

    if (userMatches.matches != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String userRegion = prefs.getString('userRegion');

      userMatches.matches.take(2).forEach((matchData) async {
        http.Response response;
        response = await http.get(
          'https://$userRegion.api.riotgames.com/lol/match/v4/matches/${matchData.gameId}',
          headers: {
            'Accept-Charset':
                'application/x-www-form-urlencoded; charset=UTF-8',
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
            'message':
                'Was not possible load the matches. Please try again later.'
          };
          notifyListeners();
          return null;
        }

        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('gameId')) {
          _isMatchesDetailsLoaded = true;
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          Map<String, dynamic> mapUserParticipant;
          final accountId = prefs.getString('accountId');

          List<PlayerModel> participantIdList = [];
          responseData['participantIdentities'].forEach((participantIdData) {
            if (accountId == participantIdData['player']['accountId']) {
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
                win: participantsData['stats']['win'],
                champLevel: participantsData['stats']['champLevel'],
                goldEarned: participantsData['stats']['goldEarned'],
                item0: participantsData['stats']['item0'],
                item1: participantsData['stats']['item1'],
                item2: participantsData['stats']['item2'],
                item3: participantsData['stats']['item3'],
                item4: participantsData['stats']['item4'],
                item5: participantsData['stats']['item5'],
                item6: participantsData['stats']['item6'],
              ),
            ));

            if (mapUserParticipant != null &&
                mapUserParticipant['participantId'] ==
                    participantsData['participantId']) {
              Iterable<TeamModel> userTeam = teamsList
                  .where((team) => team.teamId == participantsData['teamId']);
              userStats = ParticipantsStatsModel(
                assists: participantsData['stats']['assists'],
                deaths: participantsData['stats']['deaths'],
                doubleKills: participantsData['stats']['doubleKills'],
                kills: participantsData['stats']['kills'],
                pentaKills: participantsData['stats']['pentaKills'],
                quadraKills: participantsData['stats']['quadraKills'],
                tripleKills: participantsData['stats']['tripleKills'],
                win: participantsData['stats']['win'],
                champLevel: participantsData['stats']['champLevel'],
                goldEarned: participantsData['stats']['goldEarned'],
                item0: participantsData['stats']['item0'],
                item1: participantsData['stats']['item1'],
                item2: participantsData['stats']['item2'],
                item3: participantsData['stats']['item3'],
                item4: participantsData['stats']['item4'],
                item5: participantsData['stats']['item5'],
                item6: participantsData['stats']['item6'],
              );

              userTeam.first.win == 'Win' ? _win++ : _fail++;
              int _total = _win + _fail;
              double _winComplete = _win / _total * 100;
              double _failComplete = _fail / _total * 100;
              _userWinFail = {
                'win': _win,
                'fail': _fail,
                'winComplete': _winComplete,
                'failComplete': _failComplete,
                'winRemaining': 100 - _winComplete,
                'failRemaining': 100 - _failComplete,
              };

              _countDoubleKills =
                  participantsData['stats']['doubleKills'] + _countDoubleKills;
              _countTripleKills =
                  participantsData['stats']['tripleKills'] + _countTripleKills;
              _countQuadraKills =
                  participantsData['stats']['quadraKills'] + _countQuadraKills;
              _countPentaKills =
                  participantsData['stats']['pentaKills'] + _countPentaKills;

              _killSequence = [
                {'sequence': 'DOUBLE', 'count': _countDoubleKills},
                {'sequence': 'TRIPLE', 'count': _countTripleKills},
                {'sequence': 'QUADRA', 'count': _countQuadraKills},
                {'sequence': 'PENTA', 'count': _countPentaKills},
              ];

              _countKills = participantsData['stats']['kills'] + _countKills;
              _countDeaths = participantsData['stats']['deaths'] + _countDeaths;
              _countAssists =
                  participantsData['stats']['assists'] + _countAssists;

              _performance = [
                {'performance': 'KILLS', 'count': _countKills},
                {'performance': 'DEATHS', 'count': _countDeaths},
                {'performance': 'ASSISTS', 'count': _countAssists},
              ];

              DateTime _dateMatch = DateTime.fromMillisecondsSinceEpoch(
                  responseData['gameCreation']);

              _goldEarned.add({
                'matchTime': _dateMatch,
                'gold': participantsData['stats']['goldEarned']
              });
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
          _resultMessage = {'success': true, 'message': 'Matches loaded.'};
          notifyListeners();
        }
      });
      _resultMessage = {'success': true, 'message': 'Loading Matches.'};
    }
    return null;
  }
}
