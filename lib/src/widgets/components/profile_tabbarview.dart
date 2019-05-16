import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:lol/src/controllers/user_matches_controller.dart';
import 'package:lol/src/controllers/user_controller.dart';

class ProfileTabBarView extends StatelessWidget {
  //final user;
  final GlobalKey<FormState> _chartLevelKey = GlobalKey<FormState>();

  //ProfileTabBarView(this.user);

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
              Text(
                'Profile',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              SizedBox(
                height: 40.0,
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
                    duration: Duration(seconds: 1),
                    initialChartData: <CircularStackEntry>[
                      CircularStackEntry(
                        <CircularSegmentEntry>[
                          CircularSegmentEntry(
                            100.00,
                            Colors.blue[200],
                            rankKey: 'completed',
                          ),
                          CircularSegmentEntry(
                            100.00,
                            Colors.blueGrey[600],
                            rankKey: 'remaining',
                          ),
                        ],
                        rankKey: 'progress',
                      ),
                    ],
                    chartType: CircularChartType.Radial,
                    edgeStyle: SegmentEdgeStyle.round,
                    percentageValues: true,
                  )),
              Container(
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Column(
                    children: <Widget>[
                      Text('${user.getUser.summonerLevel}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          )),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Last season resume',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Level: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            Text('${user.getUser.summonerLevel}'),
                          ],
                        ),
                        SizedBox(
                          height: 2.0,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Total games: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            Text(totalGames),
                          ],
                        ),
                        SizedBox(
                          height: 2.0,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Most played at: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            Text('TOP'),
                          ],
                        ),
                        SizedBox(
                          height: 2.0,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Most played as: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            Text('Support'),
                          ],
                        ),
                        SizedBox(
                          height: 2.0,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Last match: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            Text('04/05/2019'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
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
