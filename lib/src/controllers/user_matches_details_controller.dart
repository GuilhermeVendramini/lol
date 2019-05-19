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
              ),
            ));

            if(mapUserParticipant['participantId'] == participantsData['participantId']) {
              Iterable<TeamModel> userTeam = teamsList.where((team) => team.teamId == participantsData['teamId']);
              print('-------------');
              print('Participante matchID: ${matchData.gameId}');
              print('Participante Id: ${mapUserParticipant['participantId']}');
              print('Participante teamId: ${participantsData['teamId']}');
              print('Participante team venceu: ${userTeam.first.win}');
              print('-------------');
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
