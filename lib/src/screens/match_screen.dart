import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:lol/src/controllers/campions_controller.dart';
import 'package:lol/src/controllers/user_matches_details_controller.dart';
import 'package:lol/src/models/champion_model.dart';
import 'package:lol/src/models/match_detail_model.dart';
import 'package:lol/src/models/participants_model.dart';
import 'package:lol/src/models/player_model.dart';
import 'package:provider/provider.dart';
import 'package:lol/src/controllers/api.dart';

class MatchScreen extends StatefulWidget {
  final int _matchId;

  MatchScreen(this._matchId);

  @override
  State<StatefulWidget> createState() {
    return _MatchScreenState();
  }
}

class _MatchScreenState extends State<MatchScreen> {
  @override
  Widget build(BuildContext context) {
    final userMatchesDetails = Provider.of<UserMatchesDetailsService>(context);
    MatchDetailModel _userMatch = userMatchesDetails.getMatch(widget._matchId);

    String _teamWin = 'FAIL';
    if (_userMatch.userStats.win) {
      _teamWin = 'WIN';
    }

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                _buildSliverAppBar(_teamWin),
              ];
            },
            body: Center(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: _team(_userMatch),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(String _teamWin) {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(_teamWin,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28.0,
            )),
        background: Image.asset(
          'assets/images/background.jpg',
          fit: BoxFit.cover,
          color: Colors.black.withOpacity(0.5),
          colorBlendMode: BlendMode.hardLight,
        ),
      ),
    );
  }

  Widget _team(MatchDetailModel userMatch) {
    final champions = Provider.of<ChampionsService>(context);

    if (champions.isChampionsLoaded == null) {
      champions.loadChampions();
    }

    return ListView.builder(
      physics: ScrollPhysics(),
      padding: EdgeInsets.all(0.0),
      itemBuilder: (context, index) {
        final List<ParticipantsModel> participants = userMatch.participants
            .where((participant) =>
                participant.teamId == userMatch.teams[index].teamId)
            .toList();

        Color _colorTeamWin = Colors.red[600];
        if (userMatch.teams[index].win == 'Win') {
          _colorTeamWin = Colors.cyan[600];
        }

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            color: _colorTeamWin.withOpacity(0.8),
          ),
          padding: EdgeInsets.only(top: 20.0, right: 8.0, left: 8.0),
          child: Column(
            children: <Widget>[
              Text(
                'TEAM ${index + 1}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              ListView.builder(
                padding: EdgeInsets.only(top: 0.0),
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, indexPart) {
                  PlayerModel participantIdentities = userMatch
                      .participantIdentities
                      .where((participantId) =>
                          participantId.participantId ==
                          participants[indexPart].participantId)
                      .first;

                  ChampionModel _champion;
                  String _championImage;
                  if (champions.isChampionsLoaded == true) {
                    _champion = champions
                        .getChampion(participants[indexPart].championId);
                    _championImage = 'assets/champs/images/${_champion.image}';
                  } else {
                    _championImage = 'assets/champs/images/unknown.png';
                  }

                  return Container(
                    padding: EdgeInsets.only(
                        top: 20.0, right: 8.0, left: 8.0, bottom: 20.0),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.white.withOpacity(0.4)))),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Wrap(
                          alignment: WrapAlignment.center,
                          direction: Axis.vertical,
                          children: <Widget>[
                            Container(
                              width: 80.0,
                              height: 80.0,
                              padding: EdgeInsets.all(8.0),
                              margin: EdgeInsets.only(right: 10.0),
                              alignment: AlignmentDirectional(1.0, 1.0),
                              child: Text(
                                '${participants[indexPart].stats.champLevel}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(1.0, 1.0),
                                      blurRadius: 1.0,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(160.0),
                                image: DecorationImage(
                                  image: AssetImage(_championImage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                participantIdentities.summonerName
                                    .toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                          crossAxisAlignment: WrapCrossAlignment.center,
                        ),
                        Wrap(
                          alignment: WrapAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: Wrap(
                                children: <Widget>[
                                  Container(
                                    child:
                                        participants[indexPart].stats.item0 == 0
                                            ? Image(
                                                image: AssetImage(
                                                    'assets/images/unknown.png'),
                                                height: 40.0,
                                              )
                                            : Image(
                                                image: NetworkImageWithRetry(
                                                  'http://ddragon.leagueoflegends.com/cdn/$VERSION/img/item/${participants[indexPart].stats.item0}.png',
                                                ),
                                                height: 40.0,
                                              ),
                                    padding: EdgeInsets.only(right: 4.0),
                                  ),
                                  Container(
                                    child:
                                        participants[indexPart].stats.item1 == 0
                                            ? Image(
                                                image: AssetImage(
                                                    'assets/images/unknown.png'),
                                                height: 40.0,
                                              )
                                            : Image(
                                                image: NetworkImageWithRetry(
                                                  'http://ddragon.leagueoflegends.com/cdn/$VERSION/img/item/${participants[indexPart].stats.item1}.png',
                                                ),
                                                height: 40.0,
                                              ),
                                    padding: EdgeInsets.only(right: 4.0),
                                  ),
                                  Container(
                                    child:
                                        participants[indexPart].stats.item2 == 0
                                            ? Image(
                                                image: AssetImage(
                                                    'assets/images/unknown.png'),
                                                height: 40.0,
                                              )
                                            : Image(
                                                image: NetworkImageWithRetry(
                                                  'http://ddragon.leagueoflegends.com/cdn/$VERSION/img/item/${participants[indexPart].stats.item2}.png',
                                                ),
                                                height: 40.0,
                                              ),
                                    padding: EdgeInsets.only(right: 4.0),
                                  ),
                                  Container(
                                    child:
                                        participants[indexPart].stats.item3 == 0
                                            ? Image(
                                                image: AssetImage(
                                                    'assets/images/unknown.png'),
                                                height: 40.0,
                                              )
                                            : Image(
                                                image: NetworkImageWithRetry(
                                                  'http://ddragon.leagueoflegends.com/cdn/$VERSION/img/item/${participants[indexPart].stats.item3}.png',
                                                ),
                                                height: 40.0,
                                              ),
                                    padding: EdgeInsets.only(right: 4.0),
                                  ),
                                  Container(
                                    child:
                                        participants[indexPart].stats.item4 == 0
                                            ? Image(
                                                image: AssetImage(
                                                    'assets/images/unknown.png'),
                                                height: 40.0,
                                              )
                                            : Image(
                                                image: NetworkImageWithRetry(
                                                  'http://ddragon.leagueoflegends.com/cdn/$VERSION/img/item/${participants[indexPart].stats.item4}.png',
                                                ),
                                                height: 40.0,
                                              ),
                                    padding: EdgeInsets.only(right: 4.0),
                                  ),
                                  Container(
                                    child:
                                        participants[indexPart].stats.item5 == 0
                                            ? Image(
                                                image: AssetImage(
                                                    'assets/images/unknown.png'),
                                                height: 40.0,
                                              )
                                            : Image(
                                                image: NetworkImageWithRetry(
                                                  'http://ddragon.leagueoflegends.com/cdn/$VERSION/img/item/${participants[indexPart].stats.item5}.png',
                                                ),
                                                height: 40.0,
                                              ),
                                    padding: EdgeInsets.only(right: 4.0),
                                  ),
                                  Container(
                                    child:
                                        participants[indexPart].stats.item6 == 0
                                            ? Image(
                                                image: AssetImage(
                                                    'assets/images/unknown.png'),
                                                height: 40.0,
                                              )
                                            : Image(
                                                image: NetworkImageWithRetry(
                                                  'http://ddragon.leagueoflegends.com/cdn/$VERSION/img/item/${participants[indexPart].stats.item6}.png',
                                                ),
                                                height: 40.0,
                                              ),
                                    padding: EdgeInsets.only(right: 4.0),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    ' K   D   A',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  Text(
                                    '${participants[indexPart].stats.kills} / ${participants[indexPart].stats.deaths} / ${participants[indexPart].stats.assists}',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'G',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  Text(
                                    '${participants[indexPart].stats.goldEarned}',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          crossAxisAlignment: WrapCrossAlignment.center,
                        ),
                      ],
                    ),
                  );
                },
                itemCount: participants.length,
              ),
            ],
          ),
        );
      },
      itemCount: userMatch.teams.length,
    );
  }
}
