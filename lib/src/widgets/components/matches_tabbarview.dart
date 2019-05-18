import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lol/src/models/user_matches_model.dart';
import 'package:lol/src/models/match_detail_model.dart';
import 'package:lol/src/controllers/user_matches_details_controller.dart';
import 'package:lol/src/controllers/user_matches_controller.dart';

class MatchesTabBarView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final userMatches = Provider.of<UserMatchesService>(context);
    final userMatchesDetails = Provider.of<UserMatchesDetailsService>(context);
    UserMatchesModel _userMatches;
    List<MatchDetailModel> _userMatchesDetails;

    if(userMatches.isMatchesLoaded == true) {
      _userMatches = userMatches.getUserMatches;

      if(userMatchesDetails.isMatchesDetailsLoaded == null) {
        userMatchesDetails.loadUserMatchesDetails(_userMatches);
      }
    }

    if(userMatchesDetails.isMatchesDetailsLoaded != null) {
      _userMatchesDetails = userMatchesDetails.getUserMatchesDetails;
    }

    return ListView.builder(
        itemCount: _userMatchesDetails.length,
        itemBuilder: (BuildContext context, int index) {
          return new Text(_userMatchesDetails[index].gameMode);
        }
    );
  }
}