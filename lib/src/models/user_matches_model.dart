import 'package:flutter/material.dart';
import 'package:lol/src/models/match_model.dart';

class UserMatchesModel {
  final List<MatchModel> matches;
  final int endIndex;
  final int startIndex;
  final int totalGames;

  UserMatchesModel({
    @required this.matches,
    @required this.endIndex,
    @required this.startIndex,
    @required this.totalGames,
  });
}
