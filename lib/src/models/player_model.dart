import 'package:flutter/material.dart';

class PlayerModel {
  final int participantId;
  final String summonerName;
  final String accountId;

  PlayerModel({
    @required this.participantId,
    @required this.summonerName,
    @required this.accountId,
  });
}