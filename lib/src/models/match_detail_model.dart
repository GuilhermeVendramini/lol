import 'package:flutter/material.dart';

class MatchDetailModel {
  final int seasonId;
  final int queueId;
  final int gameId;
  //final List<dynamic> participantIdentities;
  final String platformId;
  final String gameMode;
  final int mapId;
  final String gameType;
  //final List<dynamic> teams;
  //final List<dynamic> participants;
  final int gameDuration;
  final int gameCreation;

  MatchDetailModel({
    @required this.seasonId,
    @required this.queueId,
    @required this.gameId,
    //@required this.participantIdentities,
    @required this.platformId,
    @required this.gameMode,
    @required this.mapId,
    @required this.gameType,
    //@required this.teams,
    //@required this.participants,
    @required this.gameDuration,
    @required this.gameCreation,
  });
}

