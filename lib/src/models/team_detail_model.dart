import 'package:flutter/material.dart';
import 'package:lol/src/models/participants_model.dart';
import 'package:lol/src/models/team_model.dart';

class TeamDetailModel {
  final TeamModel team;
  final List<ParticipantsModel> participants;

  TeamDetailModel({
    @required this.team,
    @required this.participants,
  });
}