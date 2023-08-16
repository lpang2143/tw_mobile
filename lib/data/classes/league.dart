import 'package:tw_mobile/data/classes/team.dart';
import 'package:flutter_svg/flutter_svg.dart';

class League {
  int leagueId;
  String name;
  String logoPath;
  String sport;
  String? abbreviation;
  List<Team>? teams;

  League({
    required this.leagueId,
    required this.name,
    required this.logoPath,
    required this.sport,
    this.abbreviation = '',
    this.teams,
  });

  int getLeagueId() {
    return leagueId;
  }

  String getName() {
    return name;
  }

  String getSport() {
    return sport;
  }

  String getAbbreviation() {
    if (abbreviation != null) {
      return abbreviation.toString();
    }
    return '';
  }

  SvgPicture getLogo(double width, double height) {
    return SvgPicture.asset(
      logoPath,
      width: width,
      height: height,
    );
  }
}

String getAttributeValueById(
    List<League> leagues, int leagueId, String attributeName) {
  for (League league in leagues) {
    if (league.getLeagueId() == leagueId) {
      switch (attributeName) {
        case 'name':
          return league.getName();
        case 'sport':
          return league.getSport();
        default:
          return '';
      }
    }
  }
  return '';
}
