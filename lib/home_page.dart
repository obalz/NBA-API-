// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nba_api/model/team.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  List<Team> teams = [];

  // get teams
  Future getTeams() async {
    var response = await http.get(Uri.https('balldontlie.io', 'api/v1/teams'));
    var jsonData = jsonDecode(response.body);

    for (var eachTeam in jsonData['data']) {
      final team = Team(
        abbreviation: eachTeam['abbreviation'],
        city: eachTeam['city'],
      );
      teams.add(team);
    }

    print(teams.length);
  }

  @override
  Widget build(BuildContext context) {
    getTeams();
    return Scaffold(
      appBar: AppBar(
        title: Text("NBA TEAMS"),
        backgroundColor: Colors.lightBlue,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: getTeams(),
        builder: (context, snapshot) {
          //is it done loading? then show the team data
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(top: 8.0, left: 12.0, right: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(teams[index].abbreviation),
                    subtitle: Text(teams[index].city),
                  ),
                );
              },
            );
          }
          // if it's still loading, show loading circle
          else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
