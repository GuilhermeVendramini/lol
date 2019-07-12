import 'package:flutter/material.dart';

class UserChampionModel {
  final int championLevel;
  final int chestGranted;
  final int championPoints;
  final int championPointsSinceLastLevel;
  final int championPointsUntilNextLevel;
  final String summonerId;
  final int tokensEarned;
  final int championId;
  final String lastPlayTime;
  final String championName;
  final String championImage;

  UserChampionModel({
    @required this.championLevel,
    @required this.chestGranted,
    @required this.championPoints,
    @required this.championPointsSinceLastLevel,
    @required this.championPointsUntilNextLevel,
    @required this.summonerId,
    @required this.tokensEarned,
    @required this.championId,
    @required this.lastPlayTime,
    @required this.championName,
    @required this.championImage,
  });
}
