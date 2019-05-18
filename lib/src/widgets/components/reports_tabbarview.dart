import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:lol/src/controllers/user_matches_controller.dart';

List<dynamic> _playedAt = [];

class ReportsTabBarView extends StatelessWidget {

  final GlobalKey<FormState> _chartWonKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _chartLostKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userMatches = Provider.of<UserMatchesService>(context);
    String totalGames = '';
    String mostPlayedAt = '';
    String lastMatch = '';

    if(userMatches.isMatchesLoaded == true) {
      totalGames = '${userMatches.getUserMatches.totalGames}';
      mostPlayedAt = userMatches.mostPlayedAt['lane'];
      lastMatch = userMatches.lastMatch;
      _playedAt = userMatches.playedAt;
    }

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
                'Reports',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Text(
                'Results',
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
                height: 220.0,
                child: Card(
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
                'Resume',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Total games:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(totalGames),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Most played at:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(mostPlayedAt),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Last match:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(lastMatch),
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

// Lanes
class ChartLanes extends StatelessWidget {
  final List<charts.Series> seriesList = _createSampleData();
  final bool animate = true;

  @override
  Widget build(BuildContext context) {
    charts.Color colorTextChart = charts.Color.black;

    if(Theme.of(context).brightness == Brightness.dark) {
      colorTextChart = charts.Color.white;
    }

    return new charts.BarChart(
      seriesList,
      animate: animate,
      vertical: false,
      barRendererDecorator: charts.BarLabelDecorator(outsideLabelStyleSpec: charts.TextStyleSpec(color: colorTextChart)),


      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          // Tick and Label styling here.
          labelStyle: charts.TextStyleSpec(
            fontSize: 14, // size in Pts.
            color: charts.Color.fromOther(
              color: colorTextChart,
            ),
          ),
          labelAnchor: charts.TickLabelAnchor.centered,
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
            color: colorTextChart,
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

    List<OrdinalLanes> globalLanesData = [];
    
    _playedAt.forEach((lanes){
      globalLanesData.add(OrdinalLanes(lanes['lane'], lanes['count']));
    });
    
    return [
      charts.Series<OrdinalLanes, String>(
        id: 'Lane',
        domainFn: (OrdinalLanes lanes, _) => lanes.lane,
        measureFn: (OrdinalLanes lanes, _) => lanes.count,
        data: globalLanesData,
        labelAccessorFn: (OrdinalLanes lanes, _) => lanes.count.toString(),
        fillColorFn: (OrdinalLanes lanes, _) {
          final color = charts.MaterialPalette.blue.shadeDefault.lighter;
          return color;
        },
      ),
    ];
  }
}

class OrdinalLanes {
  final String lane;
  final int count;

  OrdinalLanes(this.lane, this.count);
}