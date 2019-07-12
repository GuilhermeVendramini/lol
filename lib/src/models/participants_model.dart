import 'package:flutter/material.dart';
import 'package:lol/src/models/participants_stats_model.dart';

class ParticipantsModel {
  final int participantId;
  final int teamId;
  final int championId;
  final ParticipantsStatsModel stats;

  ParticipantsModel({
    @required this.participantId,
    @required this.teamId,
    @required this.championId,
    @required this.stats,
  });
}
