import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:lol/src/models/user_matches_model.dart';
import 'package:lol/src/controllers/user_matches_controller.dart';
import 'package:lol/src/controllers/user_matches_details_controller.dart';

List<dynamic> _playedAt = [];
List<dynamic> _userKillSequence = [];
List<dynamic> _performance = [];

class ReportsTabBarView extends StatelessWidget {

  final GlobalKey<FormState> _chartWonKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _chartLostKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userMatches = Provider.of<UserMatchesService>(context);
    final userMatchesDetails = Provider.of<UserMatchesDetailsService>(context);
    UserMatchesModel _userMatches;
    Map<String, dynamic> _userWinFail;

    if(userMatches.isMatchesLoaded == true) {
      _playedAt = userMatches.playedAt;
      _userMatches = userMatches.getUserMatches;

      if(userMatchesDetails.isMatchesDetailsLoaded == null) {
        userMatchesDetails.loadUserMatchesDetails(_userMatches);
      }
    }

    if(userMatchesDetails.isMatchesDetailsLoaded != null) {
      _userWinFail = userMatchesDetails.userWinFail;
      _userKillSequence = userMatchesDetails.killSequence;
      _performance = userMatchesDetails.performance;
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
                height: 2.0,
              ),
              Text(
                'of the last 10 matches',
                style: TextStyle(
                  fontSize: 12.0,
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
                        holeLabel: _userWinFail != null ? '${_userWinFail['win']}' : '',
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
                                _userWinFail != null ? _userWinFail['winComplete'] : 00.0,
                                Colors.green[200],
                                rankKey: 'completed',
                              ),
                              CircularSegmentEntry(
                                _userWinFail != null ? _userWinFail['winRemaining'] : 100.0,
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
                        'Win',
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
                        holeLabel: _userWinFail != null ? '${_userWinFail['fail']}' : '',
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
                                _userWinFail != null ? _userWinFail['failComplete'] : 00.0,
                                Colors.red[200],
                                rankKey: 'completed',
                              ),
                              CircularSegmentEntry(
                                _userWinFail != null ? _userWinFail['failRemaining'] : 100.0,
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
                        'Fail',
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
                'Picked Lanes',
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
                'Performance',
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
                    child: ChartPerformance(),
                  ),
                ),
              ),
              SizedBox(
                height: 60.0,
              ),
              Text(
                'Kill Sequence',
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
                    child: ChartKillSequence(),
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
  final List<charts.Series> seriesList = _createData();
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
  static List<charts.Series<OrdinalLanes, String>> _createData() {

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

// Kill sequence
class ChartKillSequence extends StatelessWidget {
  final List<charts.Series> seriesList = _createData();
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
  static List<charts.Series<OrdinalKillSequence, String>> _createData() {

    List<OrdinalKillSequence> globalKillSequenceData = [];
    _userKillSequence.forEach((kills){
      globalKillSequenceData.add(OrdinalKillSequence(kills['sequence'], kills['count']));
    });

    return [
      charts.Series<OrdinalKillSequence, String>(
        id: 'Kill',
        domainFn: (OrdinalKillSequence kills, _) => kills.sequence,
        measureFn: (OrdinalKillSequence kills, _) => kills.count,
        data: globalKillSequenceData,
        labelAccessorFn: (OrdinalKillSequence kills, _) => kills.count.toString(),
        fillColorFn: (OrdinalKillSequence kills, _) {
          final color = charts.MaterialPalette.deepOrange.shadeDefault.lighter;
          return color;
        },
      ),
    ];
  }
}

class OrdinalKillSequence {
  final String sequence;
  final int count;

  OrdinalKillSequence(this.sequence, this.count);
}

// Performance
class ChartPerformance extends StatelessWidget {
  final List<charts.Series> seriesList = _createData();
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
  static List<charts.Series<OrdinalPerformance, String>> _createData() {

    List<OrdinalPerformance> globalPerformanceData = [];
    _performance.forEach((perf){
      globalPerformanceData.add(OrdinalPerformance(perf['performance'], perf['count']));
    });

    return [
      charts.Series<OrdinalPerformance, String>(
        id: 'Performance',
        domainFn: (OrdinalPerformance perf, _) => perf.performance,
        measureFn: (OrdinalPerformance perf, _) => perf.count,
        data: globalPerformanceData,
        labelAccessorFn: (OrdinalPerformance perf, _) => perf.count.toString(),
        fillColorFn: (OrdinalPerformance perf, _) {
          final color = charts.MaterialPalette.green.shadeDefault.lighter;
          return color;
        },
      ),
    ];
  }
}

class OrdinalPerformance {
  final String performance;
  final int count;

  OrdinalPerformance(this.performance, this.count);
}