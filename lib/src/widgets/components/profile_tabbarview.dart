import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ProfileTabBarView extends StatelessWidget {
  final user;
  final GlobalKey<FormState> _chartLevelKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _chartWonKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _chartLostKey = GlobalKey<FormState>();

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
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          //crossAxisAlignment: CrossAxisAlignment.center,
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
                height: 60.0,
              ),
              Text(
                'Lanes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                height: 180.0,
                child: Card(
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    child: ChartLanes(),
                  ),
                ),
              ),
              SizedBox(
                height: 60.0,
              ),
              Text(
                'Roles',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                height: 180.0,
                child: Card(
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    child: ChartRoles(),
                  ),
                ),
              ),
              SizedBox(
                height: 60.0,
              ),
              Text(
                'Last 10 matches',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      AnimatedCircularChart(
                        key: _chartWonKey,
                        size: const Size(160.0, 160.0),
                        holeLabel: '132',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Theme.of(context).textTheme.body1.color,
                        ),
                        duration: Duration(seconds: 1),
                        initialChartData: <CircularStackEntry>[
                          CircularStackEntry(
                            <CircularSegmentEntry>[
                              CircularSegmentEntry(
                                90.00,
                                Colors.green[200],
                                rankKey: 'completed',
                              ),
                              CircularSegmentEntry(
                                10.00,
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
                      ),
                      Text(
                        'Won',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      AnimatedCircularChart(
                        key: _chartLostKey,
                        size: const Size(160.0, 160.0),
                        holeLabel: '37',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Theme.of(context).textTheme.body1.color,
                        ),
                        duration: Duration(seconds: 1),
                        initialChartData: <CircularStackEntry>[
                          CircularStackEntry(
                            <CircularSegmentEntry>[
                              CircularSegmentEntry(
                                10.00,
                                Colors.red[200],
                                rankKey: 'completed',
                              ),
                              CircularSegmentEntry(
                                90.10,
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
                      ),
                      Text(
                        'Lost',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
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

// Lanes
class ChartLanes extends StatelessWidget {
  final List<charts.Series> seriesList = _createSampleData();
  final bool animate = true;

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      vertical: false,

      domainAxis: charts.OrdinalAxisSpec(
          renderSpec: charts.SmallTickRendererSpec(

              // Tick and Label styling here.
              labelStyle: charts.TextStyleSpec(
                  fontSize: 16, // size in Pts.
              ),

              // Change the line colors to match text color.
              lineStyle:
                  charts.LineStyleSpec(color: charts.MaterialPalette.transparent),
          ),
      ),

      /// Assign a custom style for the measure axis.
      primaryMeasureAxis: charts.NumericAxisSpec(
          renderSpec: charts.GridlineRendererSpec(

              // Tick and Label styling here.
              labelStyle: charts.TextStyleSpec(
                  fontSize: 12, // size in Pts.
              ),

              // Change the line colors to match text color.
              //lineStyle:
              //    charts.LineStyleSpec(color: charts.MaterialPalette.white)
          ),
      ),
    );
  }

  /// Create series list with single series
  static List<charts.Series<OrdinalLanes, String>> _createSampleData() {
    final globalLanesData = [
      OrdinalLanes('Top', 10),
      OrdinalLanes('Mid', 30),
      OrdinalLanes('Bottom', 75),
    ];

    return [
      charts.Series<OrdinalLanes, String>(
        id: 'Lane',
        domainFn: (OrdinalLanes sales, _) => sales.lane,
        measureFn: (OrdinalLanes sales, _) => sales.games,
        data: globalLanesData,
        fillColorFn: (OrdinalLanes sales, _) {
          final color = charts.MaterialPalette.blue.shadeDefault.lighter;
          return color;
        },
      ),
    ];
  }
}

class OrdinalLanes {
  final String lane;
  final int games;

  OrdinalLanes(this.lane, this.games);
}

// Roles
class ChartRoles extends StatelessWidget {
  final List<charts.Series> seriesList = _createSampleData();
  final bool animate = true;

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      vertical: false,

      domainAxis: charts.OrdinalAxisSpec(
          renderSpec: charts.SmallTickRendererSpec(

              // Tick and Label styling here.
              labelStyle: charts.TextStyleSpec(
                  fontSize: 16, // size in Pts.
              ),

              // Change the line colors to match text color.
              lineStyle:
                  charts.LineStyleSpec(color: charts.MaterialPalette.transparent),
          ),
      ),

      /// Assign a custom style for the measure axis.
      primaryMeasureAxis: charts.NumericAxisSpec(
          renderSpec: charts.GridlineRendererSpec(

              // Tick and Label styling here.
              labelStyle: charts.TextStyleSpec(
                  fontSize: 12, // size in Pts.
              ),

              // Change the line colors to match text color.
              //lineStyle:
              //    charts.LineStyleSpec(color: charts.MaterialPalette.white)
          ),
      ),
    );
  }

  /// Create series list with single series
  static List<charts.Series<OrdinalRoles, String>> _createSampleData() {
    final globalRolesData = [
      OrdinalRoles('Solo', 10),
      OrdinalRoles('Support', 30),
      OrdinalRoles('Carry', 75),
      OrdinalRoles('Jungle', 4),
    ];

    return [
      charts.Series<OrdinalRoles, String>(
        id: 'Lane',
        domainFn: (OrdinalRoles roles, _) => roles.role,
        measureFn: (OrdinalRoles roles, _) => roles.games,
        data: globalRolesData,
        fillColorFn: (OrdinalRoles roles, _) {
          final color = charts.MaterialPalette.yellow.shadeDefault.lighter;
          return color;
        },
      ),
    ];
  }
}

class OrdinalRoles {
  final String role;
  final int games;

  OrdinalRoles(this.role, this.games);
}
