import 'package:flutter/material.dart';
import 'package:lol/src/controllers/campions_controller.dart';
import 'package:lol/src/controllers/user_champions_controller.dart';
import 'package:lol/src/controllers/user_controller.dart';
import 'package:lol/src/models/champion_model.dart';
import 'package:lol/src/models/user_champion_model.dart';
import 'package:lol/src/screens/champion_screen.dart';
import 'package:lol/src/widgets/routes/route_fade.dart';
import 'package:provider/provider.dart';

class ChampionsTabBarView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final champions = Provider.of<ChampionsService>(context);
    final user = Provider.of<UserAuth>(context);
    final userChampions = Provider.of<UserChampionsService>(context);
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 650.0 ? 600.0 : deviceWidth * 0.95;
    List<ChampionModel> _champions = [];
    List<UserChampionModel> _userChampions = [];

    if (champions.isChampionsLoaded == null) {
      champions.loadChampions();
    }

    if (champions.isChampionsLoaded == true) {
      _champions = champions.getChampions;

      if (userChampions.isUserChampionsLoaded == null) {
        userChampions.loadUserChampions(user.getUser.id, _champions);
      }

      if (userChampions.isUserChampionsLoaded == true) {
        _userChampions = userChampions.getUserChampions;
      }
    }

    return Center(
        child: Container(
            width: targetWidth,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  'Champions',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
                SizedBox(
                  height: 2.0,
                ),
                Text(
                  'mastery information',
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                champions.isChampionsLoaded != null &&
                    champions.isChampionsLoaded == true &&
                        _userChampions.length == 0
                    ? Text('No champions mastery informations')
                    : Expanded(
                        child: GridView.builder(
                            itemCount: _userChampions.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Route route = RouteFade(
                                      builder: (context) => ChampionScreen(_userChampions[index].championId));
                                  Navigator.push(context, route);
                                },
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Image(
                                        image: AssetImage(_userChampions[index]
                                            .championImage),
                                        height: 80.0,
                                      ),
                                      Text(
                                        _userChampions[index].championName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${_userChampions[index].championLevel}',
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
              ],
            )));
  }
}
