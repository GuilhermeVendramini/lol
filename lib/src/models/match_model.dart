import 'package:flutter/material.dart';

class MatchModel {
  final String lane;
  final int gameId;
  final int champion;
  final String platformId;
  final int timestamp;
  final int queue;
  final String role;
  final int season;

  MatchModel({
    @required this.lane,
    @required this.gameId,
    @required this.champion,
    @required this.platformId,
    @required this.timestamp,
    @required this.queue,
    @required this.role,
    @required this.season,
  });
}