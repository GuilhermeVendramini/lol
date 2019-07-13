import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lol/src/controllers/api.dart';
import 'package:lol/src/models/champion_model.dart';
import 'package:lol/src/models/user_champion_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserChampionsController with ChangeNotifier {
  List<UserChampionModel> _userChampions;
  Iterable<UserChampionModel> _userChampion;
  Map<String, dynamic> _resultMessage;
  bool _isUserChampionsLoaded;
}

class UserChampions extends UserChampionsController {
  List<UserChampionModel> get getUserChampions {
    _userChampions.sort((UserChampionModel a, UserChampionModel b) {
      return b.championLevel.compareTo(a.championLevel);
    });
    return _userChampions;
  }

  UserChampionModel getUserChampion(int championId) {
    _userChampion =
        _userChampions.where((champ) => champ.championId == championId);
    return _userChampion.first;
  }

  bool get isUserChampionsLoaded {
    return _isUserChampionsLoaded;
  }

  Map<String, dynamic> get resultMessage {
    return _resultMessage;
  }

  void get clearUserChampionsValues {
    _userChampions = [];
    _resultMessage = null;
    _isUserChampionsLoaded = null;
    notifyListeners();
  }
}

class UserChampionsService extends UserChampions {
  loadUserChampions(String userId, List<ChampionModel> championList) async {
    if (_isUserChampionsLoaded != null) {
      _resultMessage = {'success': true, 'message': 'Champs already loaded.'};
      return null;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userRegion = prefs.getString('userRegion');

    http.Response response;
    response = await http.get(
      'https://$userRegion.api.riotgames.com/lol/champion-mastery/v4/champion-masteries/by-summoner/$userId',
      headers: {
        'Accept-Charset': 'application/x-www-form-urlencoded; charset=UTF-8',
        'X-Riot-Token': '$API_KEY',
      },
    ).catchError((onError) {
      _resultMessage = {
        'success': false,
        'message':
            'Was not possible to connect. Please, verify your Summoner, Region and try again.'
      };
    });

    _isUserChampionsLoaded = false;

    if (response == null) {
      notifyListeners();
      return null;
    } else if (response.statusCode != 200 && response.statusCode != 201) {
      _resultMessage = {
        'success': false,
        'message':
            'Was not possible load the Champions. Please try again later.'
      };
      notifyListeners();
      return null;
    }

    final List<dynamic> responseData = json.decode(response.body);
    _userChampions = [];
    responseData.forEach((userChampionData) {
      Iterable<dynamic> findChampion = championList.where(
          ((champ) => int.parse(champ.key) == userChampionData['championId']));
      ChampionModel champion;
      if (findChampion.isNotEmpty) {
        champion = findChampion.first;
      }

      DateTime _lastPlayTime =
          DateTime.fromMillisecondsSinceEpoch(userChampionData['lastPlayTime']);
      String _lastPlayTimeFormatted =
          DateFormat('dd/MM/yy').add_jm().format(_lastPlayTime);

      final UserChampionModel userChampion = UserChampionModel(
        championLevel: userChampionData['championLevel'],
        chestGranted: userChampionData['chestGranted'] == true ? 1 : 0,
        championPoints: userChampionData['championPoints'],
        championPointsSinceLastLevel:
            userChampionData['championPointsSinceLastLevel'],
        championPointsUntilNextLevel:
            userChampionData['championPointsUntilNextLevel'],
        summonerId: userChampionData['summonerId'],
        tokensEarned: userChampionData['tokensEarned'],
        championId: userChampionData['championId'],
        lastPlayTime: _lastPlayTimeFormatted,
        championName: champion != null ? champion.name : 'unknown',
        championImage: champion != null
            ? 'assets/champs/images/${champion.image}'
            : 'assets/champs/images/unknown.png',
      );
      _isUserChampionsLoaded = true;
      _userChampions.add(userChampion);
      _resultMessage = {'success': true, 'message': 'User Champions loaded.'};
      notifyListeners();
    });
    _resultMessage = {'success': true, 'message': 'Loading User Champions.'};
    notifyListeners();
    return null;
  }
}
