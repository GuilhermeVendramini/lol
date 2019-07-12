import 'package:flutter/material.dart';
import 'package:lol/src/controllers/user_controller.dart';
import 'package:lol/src/widgets/components/champions_tabbarview.dart';
import 'package:lol/src/widgets/components/matches_tabbarview.dart';
import 'package:lol/src/widgets/components/profile_tabbarview.dart';
import 'package:lol/src/widgets/components/reports_tabbarview.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserAuth>(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
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
          body: TabBarView(
            children: <Widget>[
              ProfileTabBarView(),
              MatchesTabBarView(),
              ChampionsTabBarView(),
              ReportsTabBarView(),
            ],
          ),
          bottomNavigationBar: _buildTabBar(context),
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return TabBar(
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
        Tab(
          icon: Icon(
            Icons.insert_chart,
            color: Theme.of(context).textTheme.body1.color,
          ),
          text: 'Reports',
        ),
      ],
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
