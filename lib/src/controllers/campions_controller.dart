import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:lol/src/models/champion_model.dart';

class ChampionsController with ChangeNotifier {
  List<ChampionModel> _champions;
  Iterable<ChampionModel> _champion;
  bool _isChampionsLoaded;
}

class Champions extends ChampionsController {
  List<ChampionModel> get getChampions {
    return _champions;
  }

  ChampionModel getChampion(int championId) {
    _champion = _champions.where((champ) => champ.key == championId.toString());
    return _champion.first;
  }

  bool get isChampionsLoaded {
    return _isChampionsLoaded;
  }

  void get clearChampionsValues {
    _champions = null;
    _isChampionsLoaded = null;
    notifyListeners();
  }
}

class ChampionsService extends Champions {
  Future<Map<String, dynamic>> loadChampions() async {
    if(_isChampionsLoaded != null) {
      return {'success': true, 'message': 'Champs already loaded.'};
    }

    Future<String> _loadChampionsJson() async {
      return await rootBundle.loadString('assets/champs/champs.json');
    }

    _champions = [];
    Future<void> loadChampionsList() async {
      String championsJsonString = await _loadChampionsJson();
      final championsJsonResponse = json.decode(championsJsonString);
      Map<String, dynamic> championsMap = championsJsonResponse['data'];
      championsMap.forEach((index, championData){
        ChampionModel champion = ChampionModel.fromJson(championData);
        _champions.add(champion);
        _isChampionsLoaded = true;
        notifyListeners();
      });
    }

    loadChampionsList();

    return {
      'success': true,
      'message': 'Matches details loaded.'
    };
  }
}