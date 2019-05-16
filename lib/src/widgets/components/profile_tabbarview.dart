import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

class ProfileTabBarView extends StatelessWidget {
  final user;
  final GlobalKey<FormState> _chartLevelKey = GlobalKey<FormState>();

  ProfileTabBarView(this.user);

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 650.0 ? 600.0 : deviceWidth * 0.95;
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
                            33.33,
                            Colors.blue[200],
                            rankKey: 'completed',
                          ),
                          CircularSegmentEntry(
                            66.67,
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
                          'Resume',
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
                              'Level reputation: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            Text('${user.getUser.summonerLevel}'),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Total Games: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            Text('218'),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Mastery score: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            Text('316'),
                          ],
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
