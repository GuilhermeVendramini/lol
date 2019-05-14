import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

class ProfileTabBarView extends StatelessWidget {
  final user;
  final GlobalKey<FormState> _chartKey = GlobalKey<FormState>();
  ProfileTabBarView(this.user);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 30.0,
        ),
/*        Container(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          alignment: FractionalOffset.center,
          child:
          CircleAvatar(backgroundImage:  AssetImage('assets/images/avatar.png'), radius: 60.0),
        ),*/
        Container(
          width: 160.0,
          height: 160.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(160.0),
            image: DecorationImage(
              image: AssetImage('assets/images/avatar.png'),
              fit: BoxFit.cover,
            ),
          ),
          child:
            AnimatedCircularChart(
              key: _chartKey,
              size: const Size(200.0, 200.0),
              //holeLabel: 'Level ${user.getUser.summonerLevel}',
              initialChartData: <CircularStackEntry>[
                CircularStackEntry(
                  <CircularSegmentEntry>[
                    CircularSegmentEntry(
                      33.33,
                      Colors.cyan[600],
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
            )
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Column(
              children: <Widget>[
                Text(
                    'Level',
                    style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                    '${user.getUser.summonerLevel}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)
                ),
              ],
            ),
          ),
        ),
      ],
    );;
  }
}