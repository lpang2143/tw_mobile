import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Team {
  int teamId;
  String teamName;
  String arenaName;
  String arenaLocation;
  String state;
  String logoPath;
  String abbName;
  int leagueId;
  Color color;

  Team({
    required this.teamId,
    required this.teamName,
    required this.arenaName,
    required this.arenaLocation,
    required this.state,
    required this.logoPath,
    required this.abbName,
    required this.leagueId,
    required this.color,
  });

  int getTeamId() {
    return teamId;
  }

  String getTeamName() {
    return teamName;
  }

  String getArenaName() {
    return arenaName;
  }

  String getArenaLocation() {
    return arenaLocation;
  }

  String getState() {
    return state;
  }

  SvgPicture getLogo(double width, double height) {
    return SvgPicture.asset(
      logoPath,
      width: width,
      height: height,
    );
  }

  String getAbbName() {
    return abbName;
  }

  int getLeagueId() {
    return leagueId;
  }

  Color getColor() {
    return color;
  }

  String getColorString() {
    return color.toString();
  }
}

String getAttributeValueById(
    List<Team> teams, int teamId, String attributeName) {
  for (Team team in teams) {
    if (team.getTeamId() == teamId) {
      switch (attributeName) {
        case 'teamName':
          return team.getTeamName();
        case 'arenaName':
          return team.getArenaName();
        case 'arenaLocation':
          return team.getArenaLocation();
        case 'state':
          return team.getState();
        case 'logoPath':
          return team.logoPath;
        case 'abbName':
          return team.getAbbName();
        case 'leagueId':
          return team.getLeagueId().toString();
        case 'color':
          return team.getColorString();
        default:
          return '';
      }
    }
  }
  return '';
}
