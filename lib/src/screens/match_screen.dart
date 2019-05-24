import 'package:flutter/material.dart';
import 'package:lol/src/controllers/user_matches_details_controller.dart';
import 'package:lol/src/models/match_detail_model.dart';
import 'package:lol/src/models/participants_model.dart';
import 'package:provider/provider.dart';
import 'package:lol/src/controllers/user_controller.dart';

class MatchScreen extends StatefulWidget {
  final int _matchId;

  MatchScreen(this._matchId);

  @override
  State<StatefulWidget> createState() {
    return _MatchScreenState();
  }
}

class _MatchScreenState extends State<MatchScreen> {
  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 650.0 ? 600.0 : deviceWidth * 0.95;
    final user = Provider.of<UserAuth>(context);

    final userMatchesDetails = Provider.of<UserMatchesDetailsService>(context);
    MatchDetailModel _userMatch = userMatchesDetails.getMatch(widget._matchId);

    Color _colorTeamWin = Colors.red[600];
    String _teamWin = 'Fail';
    if (_userMatch.userStats.win) {
      _colorTeamWin = Colors.cyan[600];
      _teamWin = 'Win';
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
      },
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          drawer: _buildSideDrawer(context),
          appBar: AppBar(
            title: Text(user.getUser.name),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/settings');
                },
              ),
            ],
          ),
          body: Center(
            heightFactor: 2.0,
              child: Container(
                width: targetWidth,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40.0,
                    ),
                    Text(
                      _teamWin,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                        color: _colorTeamWin,
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Expanded(
                      child: _team(_userMatch),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
/*                    Expanded(
                      child: _team(200),
                    ),*/
                  ],
                ),
              ),
          ),
        ),
      ),
    );
  }

  Widget _team(MatchDetailModel userMatch) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final List<ParticipantsModel> participants = userMatch.participants.where((participant) => participant.teamId == userMatch.teams[index].teamId).toList();
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text(
                userMatch.teams[index].win,
                style: Theme.of(context).textTheme.body2,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, indexPart) {
                    return Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(participants[indexPart].participantId.toString()),
                    );
                  },
                  itemCount: participants.length,
                ),
            ],
          ),
        );
      },
      itemCount: userMatch.teams.length,
    );
  }

  Widget _buildSideDrawer(BuildContext context) {
    final user = Provider.of<UserAuth>(context);
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Menu'),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              user.userLogout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}
