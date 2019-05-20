import 'package:flutter/material.dart';
import 'package:lol/src/controllers/user_champions_controller.dart';
import 'package:lol/src/controllers/user_controller.dart';
import 'package:lol/src/models/user_champion_model.dart';
import 'package:provider/provider.dart';

class ChampionsTabBarView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserAuth>(context);
    final userChampions = Provider.of<UserChampionsService>(context);
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 650.0 ? 600.0 : deviceWidth * 0.95;
    List<UserChampionModel> _userChampions = [];

    if(userChampions.isChampionsLoaded == null) {
      userChampions.loadUserChampions(user.getUser.id);
    }

    if(userChampions.isChampionsLoaded == true) {
      _userChampions = userChampions.getUserChampions;
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
                  height: 40.0,
                ),
                Expanded(
                  child: GridView.builder(
                      itemCount: _userChampions.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          //padding: EdgeInsets.all(10.0),
                          //color: Colors.red,
                          child: Column(children: <Widget>[
                            Image(
                              image: AssetImage(_userChampions[index].championImage),
                            ),
                            Text(_userChampions[index].championName),
                          ],),
                        );
                      }
                  ),
                ),
              ],
            )
        )
    );
  }
}