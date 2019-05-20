import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:lol/src/models/user_champion_model.dart';
import 'package:http/http.dart' as http;
import 'package:lol/src/controllers/api.dart';

class UserChampionsController with ChangeNotifier {
  List<UserChampionModel> _userChampions;
  bool _isChampionsLoaded;
}

class UserChampions extends UserChampionsController {
  List<UserChampionModel> get getUserChampions {
    return _userChampions;
  }

  bool get isChampionsLoaded {
    return _isChampionsLoaded;
  }

  void get clearChampionsValues {
    _userChampions = null;
    _isChampionsLoaded = null;
    notifyListeners();
  }
}

class UserChampionsService extends UserChampions {
  Future<Map<String, dynamic>> loadUserChampions(String userId) async {
    if(_isChampionsLoaded != null) {
      return {'success': true, 'message': 'Champs already loaded.'};
    }

    Future<String> loadChampionsJson() async {
      return await rootBundle.loadString('assets/champs/champs.json');
    }

    Map<String, dynamic> champions;
    Future<String> _loadChampionsJson = loadChampionsJson();

    _loadChampionsJson.then((onValue){
      Map championsJson = jsonDecode(onValue);
      champions = championsJson['data'];
    });

    http.Response response;
    response = await http.get(
      'https://na1.api.riotgames.com/lol/champion-mastery/v4/champion-masteries/by-summoner/$userId',
      headers: {
        'Accept-Charset': 'application/x-www-form-urlencoded; charset=UTF-8',
        'X-Riot-Token': '$API_KEY',
      },
    );

    if(response.statusCode != 200 && response.statusCode != 201) {
      _isChampionsLoaded = false;
      notifyListeners();
      return {
        'success': false,
        'message': 'Error load user champions.'
      };
    }

    _userChampions = [];
    final List<dynamic> responseData = json.decode(response.body);

    responseData.forEach((userChampionData){
      Iterable<dynamic> findChampion = champions.values.where(((champ) => int.parse(champ['key']) == userChampionData['championId']));
      Map<String, dynamic> champion = {};
      if(findChampion.isNotEmpty) {
        champion = findChampion.first;
      }

      final UserChampionModel userChampion = UserChampionModel(
        championLevel: userChampionData['championLevel'],
        chestGranted: userChampionData['chestGranted'] == true ? 1 : 0,
        championPoints: userChampionData['championPoints'],
        championPointsSinceLastLevel: userChampionData['championPointsSinceLastLevel'],
        championPointsUntilNextLevel: userChampionData['championPointsUntilNextLevel'],
        summonerId: userChampionData['summonerId'],
        tokensEarned: userChampionData['tokensEarned'],
        championId: userChampionData['championId'],
        lastPlayTime: userChampionData['lastPlayTime'],
        championName: champion['name'] != null
            ? champion['name'] : 'unknown',
        championImage: champion['image'] != null
            ? 'assets/champs/images/${champion['image']['full']}'
            : 'assets/champs/images/unknown.png',
      );
      _isChampionsLoaded = true;
      _userChampions.add(userChampion);
      notifyListeners();
    });

    return {
      'success': true,
      'message': 'Matches details loaded.'
    };
  }
}