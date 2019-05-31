import 'package:flutter/material.dart';
import 'package:lol/src/controllers/campions_controller.dart';
import 'package:lol/src/controllers/user_champions_controller.dart';
import 'package:lol/src/models/champion_model.dart';
import 'package:lol/src/models/user_champion_model.dart';
import 'package:provider/provider.dart';
import 'package:lol/src/controllers/user_controller.dart';

class ChampionScreen extends StatefulWidget {
  final int _championId;

  ChampionScreen(this._championId);

  @override
  State<StatefulWidget> createState() {
    return _ChampionScreenState();
  }
}

class _ChampionScreenState extends State<ChampionScreen> {
  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 650.0 ? 600.0 : deviceWidth * 0.95;
    final user = Provider.of<UserAuth>(context);
    final userChampions = Provider.of<UserChampionsService>(context);
    final champions = Provider.of<ChampionsService>(context);
    final UserChampionModel userChampion =
        userChampions.getUserChampion(widget._championId);
    final ChampionModel champion = champions.getChampion(widget._championId);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
      },
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          drawer: _buildSideDrawer(context),
          appBar: AppBar(
            title: Text(user.getUser.name),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/settings');
                },
              ),
            ],
          ),
          body: Center(
            heightFactor: 2.0,
            child: SingleChildScrollView(
              child: Container(
                width: targetWidth,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40.0,
                    ),
                    Hero(
                      tag: userChampion.championImage,
                      child: Image(
                        image: AssetImage(userChampion.championImage),
                      ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      userChampion.championName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      '${userChampion.championLevel}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Text(
                      'Mastery information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    _buildChampsInfo(userChampion),
                    SizedBox(
                      height: 40.0,
                    ),
                    Text(
                      '${userChampion.championName}\'s profile',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    _buildChampsProfile(champion),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChampsInfo(UserChampionModel userChampion) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Card(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'Points: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('${userChampion.championPoints}'),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Points to the next level: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                      '${userChampion.championPointsUntilNextLevel}'),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Current level points: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                      '${userChampion.championPointsSinceLastLevel}'),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Season chest: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  userChampion.chestGranted == 1
                      ? Text('Yes')
                      : Text('No'),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Tokens earned: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('${userChampion.tokensEarned}'),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Last time played: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(userChampion.lastPlayTime),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChampsProfile(ChampionModel champion) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Card(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Text(champion.title),
              SizedBox(
                height: 10.0,
              ),
              Text(champion.blurb),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Attack: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('${champion.info['attack']}'),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Defense: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('${champion.info['defense']}'),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Magic: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('${champion.info['magic']}'),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Difficulty: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('${champion.info['difficulty']}'),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Type: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: champion.tags.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Text(champion.tags[index]);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSideDrawer(BuildContext context) {
    final user = Provider.of<UserAuth>(context);
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Menu'),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              user.userLogout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}
