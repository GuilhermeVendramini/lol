import 'dart:async' show Future;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:lol/src/models/champion_model.dart';

class ChampionsController with ChangeNotifier {
  List<ChampionModel> _champions;
  Iterable<ChampionModel> _champion;
  Map<String, dynamic> _resultMessage;
  bool _isChampionsLoaded;
}

class Champions extends ChampionsController {
  List<ChampionModel> get getChampions {
    return _champions;
  }

  ChampionModel getChampion(int championId) {
    _champion = _champions.where((champ) => champ.key == championId.toString());

    if (_champion.isEmpty) {
      return ChampionModel(name: 'unknown', image: 'unknown.png');
    }

    return _champion?.first;
  }

  Map<String, dynamic> get resultMessage {
    return _resultMessage;
  }

  bool get isChampionsLoaded {
    return _isChampionsLoaded;
  }

  void get clearChampionsValues {
    _champions = null;
    _resultMessage = null;
    _isChampionsLoaded = null;
    notifyListeners();
  }
}

class ChampionsService extends Champions {
  loadChampions() async {
    if (_isChampionsLoaded != null) {
      _resultMessage = {'success': true, 'message': 'Champs already loaded.'};
      return null;
    }

    Future<String> _loadChampionsJson() async {
      return await rootBundle.loadString('assets/champs/champs.json');
    }

    _champions = [];
    Future<void> loadChampionsList() async {
      String championsJsonString = await _loadChampionsJson();
      final championsJsonResponse = json.decode(championsJsonString);
      Map<String, dynamic> championsMap = championsJsonResponse['data'];
      championsMap.forEach((index, championData) {
        ChampionModel champion = ChampionModel.fromJson(championData);
        _champions.add(champion);
        _isChampionsLoaded = true;
        _resultMessage = {'success': true, 'message': 'User Champions loaded.'};
        notifyListeners();
      });
    }

    loadChampionsList();

    _resultMessage = {'success': true, 'message': 'Loading User Champions.'};
    return null;
  }
}
