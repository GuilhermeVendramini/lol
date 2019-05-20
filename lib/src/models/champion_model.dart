import 'package:flutter/material.dart';

class ChampionModel {
  final String name;
  final String id;
  final String key;
  final String title;
  final String blurb;
  final Map<String, dynamic> info;
  final String image;
  final List<dynamic> tags;
  final String partype;

  ChampionModel({
    @required this.name,
    @required this.id,
    @required this.key,
    @required this.title,
    @required this.blurb,
    @required this.info,
    @required this.image,
    @required this.tags,
    @required this.partype,
  });

  factory ChampionModel.fromJson(Map<String, dynamic> parsedJson){
    return ChampionModel(
        name: parsedJson['name'],
        id: parsedJson['id'],
        key: parsedJson['key'],
        title: parsedJson['title'],
        blurb: parsedJson['blurb'],
        info: parsedJson['info'],
        image: parsedJson['image']['full'],
        tags: parsedJson['tags'],
        partype: parsedJson['partype'],
    );
  }
}