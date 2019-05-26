import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:lol/src/screens/match_screen.dart';
import 'package:provider/provider.dart';
import 'package:lol/src/widgets/routes/route_fade.dart';
import 'package:lol/src/models/user_matches_model.dart';
import 'package:lol/src/models/match_detail_model.dart';
import 'package:lol/src/controllers/user_matches_details_controller.dart';
import 'package:lol/src/controllers/user_matches_controller.dart';

class MatchesTabBarView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 650.0 ? 600.0 : deviceWidth * 0.95;
    final userMatches = Provider.of<UserMatchesService>(context);
    final userMatchesDetails = Provider.of<UserMatchesDetailsService>(context);
    UserMatchesModel _userMatches;
    List<MatchDetailModel> _userMatchesDetails = [];

    if (userMatches.isMatchesLoaded == true) {
      _userMatches = userMatches.getUserMatches;

      if (userMatchesDetails.isMatchesDetailsLoaded == null) {
        userMatchesDetails.loadUserMatchesDetails(_userMatches);
      }
    }

    if (userMatchesDetails.isMatchesDetailsLoaded != null) {
      _userMatchesDetails = userMatchesDetails.getUserMatchesDetails;
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
                  'Matches',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: _userMatchesDetails.length,
                      itemBuilder: (BuildContext context, int index) {
                        Color _colorTeamWin = Colors.red[600];
                        String _teamWin = 'Fail';
                        if (_userMatchesDetails[index].userStats.win) {
                          _colorTeamWin = Colors.cyan[600];
                          _teamWin = 'Win';
                        }

                        DateTime _dateMatch =
                            DateTime.fromMillisecondsSinceEpoch(
                                _userMatchesDetails[index].timestamp);
                        String _dateMatchFormatted =
                            DateFormat('dd/MM/yy').add_jm().format(_dateMatch);
                        int _gameDuration = Duration(
                                seconds:
                                    _userMatchesDetails[index].gameDuration)
                            .inMinutes;

                        return GestureDetector(
                          onTap: () {
                            Route route = RouteFade(
                                builder: (context) => MatchScreen(_userMatchesDetails[index].gameId));
                            Navigator.push(context, route);
                          },
                          child: Card(
                            child: Container(
                              padding: EdgeInsets.all(18.0),
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                alignment: WrapAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: _colorTeamWin),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.all(2.0),
                                          child:
                                          Text(
                                            _teamWin,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                              color: _colorTeamWin,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(top: 2.0),
                                          child: Text(
                                            '${_userMatchesDetails[index].userStats.champLevel}',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 10.0, right: 10.0, bottom: 10.0),
                                    child: Text(
                                      _userMatchesDetails[index].gameMode,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                  Container(
                                      padding: EdgeInsets.only(
                                          top: 10.0, right: 10.0, bottom: 10.0),
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            ' K   D   A',
                                            style: TextStyle(
                                              fontSize: 12.0,
                                            ),
                                          ),
                                          Text(
                                            '${_userMatchesDetails[index].userStats.kills} / ${_userMatchesDetails[index].userStats.deaths} / ${_userMatchesDetails[index].userStats.assists}',
                                            style: TextStyle(
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ],
                                      )),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 10.0, right: 10.0, bottom: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          _dateMatchFormatted,
                                          style: TextStyle(
                                            fontSize: 10.0,
                                          ),
                                        ),
                                        Text(
                                          'Duration: $_gameDuration m',
                                          style: TextStyle(
                                            fontSize: 10.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            )));
  }
}
