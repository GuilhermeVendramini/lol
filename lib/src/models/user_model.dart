import 'package:flutter/material.dart';

class UserModel {
  final int profileIconId;
  final String name;
  final String puuid;
  final int summonerLevel;
  final String accountId;
  final String id;
  final int revisionDate;

  UserModel({
    @required this.profileIconId,
    @required this.name,
    @required this.puuid,
    @required this.summonerLevel,
    @required this.accountId,
    @required this.id,
    @required this.revisionDate,
  });
}