import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lol/src/controllers/user_controller.dart';
import 'package:lol/src/widgets/components/profile_tabbarview.dart';
import 'package:lol/src/widgets/components/matches_tabbarview.dart';
import 'package:lol/src/widgets/components/reports_tabbarview.dart';
import 'package:lol/src/widgets/components/champions_tabbarview.dart';
import 'package:lol/src/controllers/user_matches_controller.dart';

class BaseScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserAuth>(context);
    return WillPopScope(onWillPop: () async {
      return false;//Navigator.pushReplacementNamed(context, '/profile');
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
                onPressed: () {},
              ),
            ],
          ),
          body: BaseScreenStateful(),
          bottomNavigationBar: TabBar(
            labelColor: Theme.of(context).textTheme.body1.color,
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  Icons.person,
                  color: Theme.of(context).textTheme.body1.color,
                ),
                text: 'Profile',
              ),
              Tab(
                icon: Icon(
                  Icons.insert_chart,
                  color: Theme.of(context).textTheme.body1.color,
                ),
                text: 'Reports',
              ),
              Tab(
                icon: Icon(
                  Icons.games,
                  color: Theme.of(context).textTheme.body1.color,
                ),
                text: 'Matches',
              ),
              Tab(
                icon: Icon(
                  Icons.security,
                  color: Theme.of(context).textTheme.body1.color,
                ),
                text: 'Champs',
              ),
            ],
          ),
        ),
      ),
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

class BaseScreenStateful extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BaseScreenState();
  }
}

class _BaseScreenState extends State<BaseScreenStateful> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserMatchesService>(
      builder: (_) => UserMatchesService(),
      child:  BaseScreenView(),
    );
  }
}

class BaseScreenView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BaseScreenViewState();
  }
}

class _BaseScreenViewState extends State<BaseScreenView> {
  Widget build(BuildContext context) {
    return TabBarView(
      children: <Widget>[
        ProfileTabBarView(),
        ReportsTabBarView(),
        MatchesTabBarView(),
        ChampionsTabBarView(),
      ],
    );
  }
}