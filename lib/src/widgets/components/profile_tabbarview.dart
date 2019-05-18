import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:lol/src/controllers/user_matches_controller.dart';
import 'package:lol/src/controllers/user_controller.dart';

class ProfileTabBarView extends StatelessWidget {

  final GlobalKey<FormState> _chartLevelKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 650.0 ? 600.0 : deviceWidth * 0.95;
    final user = Provider.of<UserAuth>(context);
    final userMatches = Provider.of<UserMatchesService>(context);
    String totalGames = '';

    if(userMatches.isMatchesLoaded == null) {
      userMatches.loadUserMatches(user.getUser.accountId);
    }

    if(userMatches.isMatchesLoaded == true) {
      totalGames = '${userMatches.getUserMatches.totalGames}';
    }

    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: targetWidth,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),
              Container(
                  width: 160.0,
                  height: 160.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(160.0),
                    image: DecorationImage(
                      image: NetworkImage(user.getUser.avatar),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: AnimatedCircularChart(
                    key: _chartLevelKey,
                    size: const Size(200.0, 200.0),
                    initialChartData: <CircularStackEntry>[
                      CircularStackEntry(
                        <CircularSegmentEntry>[
                          CircularSegmentEntry(
                            100.00,
                            Colors.cyan[600],
                            rankKey: 'completed',
                          ),
                        ],
                        rankKey: 'progress',
                      ),
                    ],
                    chartType: CircularChartType.Radial,
                    edgeStyle: SegmentEdgeStyle.round,
                    percentageValues: true,
                  ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text('Welcome'),
              Text(
                user.getUser.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              SizedBox(
                height: 60.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Image(
                        height: 180,
                        image: AssetImage(user.levelUserImage),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'LEVEL',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        '${user.getUser.summonerLevel}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Image(
                        height: 180,
                        width: 170,
                        image: AssetImage('assets/images/icon.png'),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'TOTAL GAMES',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        totalGames,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 40.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
