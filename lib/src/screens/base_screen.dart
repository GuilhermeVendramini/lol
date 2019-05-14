import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lol/src/controllers/user_controller.dart';
import 'package:lol/src/widgets/components/profile_tabbarview.dart';
import 'package:lol/src/widgets/components/matches_tabbarview.dart';
import 'package:lol/src/widgets/components/news_tabbarview.dart';
import 'package:lol/src/widgets/components/favorites_tabbarview.dart';

class BaseScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserAuth>(context);
    return WillPopScope(onWillPop: () async {
      Navigator.pushReplacementNamed(context, '/profile');
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
          body: TabBarView(
            children: <Widget>[
              ProfileTabBarView(user),
              MatchesTabBarView(),
              NewsTabBarView(),
              FavoritesTabBarView(),
            ],
          ),
          bottomNavigationBar: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.person),
                text: 'Profile',
              ),
              Tab(
                icon: Icon(Icons.games),
                text: 'Matches',
              ),
              Tab(
                icon: Icon(Icons.feedback),
                text: 'News',
              ),
              Tab(
                icon: Icon(Icons.favorite),
                text: 'Favorites',
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
            leading: Icon(Icons.home),
            title: Text('Home'),
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