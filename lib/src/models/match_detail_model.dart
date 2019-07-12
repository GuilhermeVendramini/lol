import 'package:flutter/material.dart';
import 'package:lol/src/models/participants_model.dart';
import 'package:lol/src/models/participants_stats_model.dart';
import 'package:lol/src/models/player_model.dart';
import 'package:lol/src/models/team_model.dart';

class MatchDetailModel {
  final int seasonId;
  final int queueId;
  final int gameId;
  final List<PlayerModel> participantIdentities;
  final String platformId;
  final String gameMode;
  final int mapId;
  final String gameType;
  final List<TeamModel> teams;
  final List<ParticipantsModel> participants;
  final int gameDuration;
  final int gameCreation;
  final ParticipantsStatsModel userStats;
  final int timestamp;

  MatchDetailModel({
    @required this.seasonId,
    @required this.queueId,
    @required this.gameId,
    @required this.participantIdentities,
    @required this.platformId,
    @required this.gameMode,
    @required this.mapId,
    @required this.gameType,
    @required this.teams,
    @required this.participants,
    @required this.gameDuration,
    @required this.gameCreation,
    @required this.userStats,
    @required this.timestamp,
  });
}
