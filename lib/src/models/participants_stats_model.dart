import 'package:flutter/material.dart';

class ParticipantsStatsModel {
  final int tripleKills;
  final int kills;
  final int quadraKills;
  final int assists;
  final bool win;
  final int deaths;
  final int pentaKills;
  final int doubleKills;
  final int champLevel;

  ParticipantsStatsModel({
    @required this.tripleKills,
    @required this.kills,
    @required this.quadraKills,
    @required this.assists,
    @required this.win,
    @required this.deaths,
    @required this.pentaKills,
    @required this.doubleKills,
    @required this.champLevel,
  });
}