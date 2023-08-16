import 'package:tw_mobile/classes/leagues/mlb.dart';
import 'package:tw_mobile/classes/leagues/mls.dart';
import 'package:tw_mobile/classes/leagues/nba.dart';
import 'package:tw_mobile/classes/leagues/nfl.dart';
import 'package:tw_mobile/classes/leagues/nhl.dart';
import 'package:tw_mobile/classes/leagues/nwsl.dart';
import 'package:tw_mobile/classes/leagues/wnba.dart';
import 'package:tw_mobile/data/classes/league.dart';
import 'package:tw_mobile/data/classes/team.dart';

List<League> leagueList = [
  League(
    leagueId: 2,
    name: 'National Football League',
    abbreviation: 'NFL',
    logoPath: 'lib/assets/leagues/nfl/nfl.svg',
    sport: 'American Football',
    teams: nflTeams,
  ),
  League(
    leagueId: 1,
    name: 'National Basketball Association',
    abbreviation: 'NBA',
    logoPath: 'lib/assets/leagues/nba/nba.svg',
    sport: 'Basketball',
    teams: nbaTeams,
  ),
  League(
    leagueId: 4,
    name: 'Major League Baseball',
    abbreviation: 'MLB',
    logoPath: 'lib/assets/league/mlb/mlb.svg',
    sport: 'Baseball',
    teams: mlbTeams,
  ),
  League(
    leagueId: 3,
    name: 'National Hockey League',
    abbreviation: 'NHL',
    logoPath: 'lib/assets/league/nhl/nhl.svg',
    sport: 'Ice Hockey',
    teams: nhlTeams,
  ),
  League(
    leagueId: 5,
    name: 'Major League Soccer',
    abbreviation: 'MLS',
    logoPath: 'lib/assets/league/mls/mls.svg',
    sport: 'Soccer',
    teams: mlsTeams,
  ),
  League(
    leagueId: 6,
    name: 'Women\'s National Basketball Association',
    abbreviation: 'WNBA',
    logoPath: 'lib/assets/league/wnba/wnba.svg',
    sport: 'Basketball',
    teams: wnbaTeams,
  ),
  League(
    leagueId: 7,
    name: 'National Women\'s Soccer League',
    abbreviation: 'NWSL',
    logoPath: 'lib/assets/league/nwsl/nwsl.svg',
    sport: 'Soccer',
    teams: nwslTeams,
  ),
  // League(
  //   leagueId: 8,
  //   name: 'Ultimate Fighting Championship',
  //   abbreviation: 'UFC',
  //   logoPath: 'https://example.com/ufc_logo.png',
  //   sport: 'Mixed Martial Arts',
  // ),
  // League(
  //   leagueId: 9,
  //   name: 'Professional Golfers\' Association',
  //   abbreviation: 'PGA',
  //   logoPath: 'https://example.com/pga_logo.png',
  //   sport: 'Golf',
  // ),
];

League getLeagueById(int leagueId) {
  return leagueList.firstWhere((league) => league.leagueId == leagueId);
}

Team getTeamById(int teamId, League league) {
  return league.teams!.firstWhere((team) => team.teamId == teamId);
}
