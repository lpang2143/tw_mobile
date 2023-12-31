import 'package:flutter/material.dart';
import 'package:tw_mobile/data/classes/team.dart';

List<Team> mlbTeams = [
  Team(
    teamId: 90,
    teamName: 'Arizona Diamondbacks',
    arenaName: 'Chase Field',
    arenaLocation: 'Phoenix, Arizona',
    state: 'Arizona',
    logoPath: 'lib/assets/leagues/mlb/diamondbacks.svg',
    abbName: 'ARI',
    leagueId: 4,
    color: const Color(0xFFA71930),
  ),
  Team(
    teamId: 91,
    teamName: 'Atlanta Braves',
    arenaName: 'Truist Park',
    arenaLocation: 'Atlanta, Georgia',
    state: 'Georgia',
    logoPath: 'lib/assets/leagues/mlb/braves.svg',
    abbName: 'ATL',
    leagueId: 4,
    color: const Color(0xFFCE1141),
  ),
  Team(
    teamId: 92,
    teamName: 'Baltimore Orioles',
    arenaName: 'Oriole Park at Camden Yards',
    arenaLocation: 'Baltimore, Maryland',
    state: 'Maryland',
    logoPath: 'lib/assets/leagues/mlb/orioles.svg',
    abbName: 'BAL',
    leagueId: 4,
    color: const Color(0xFFDF4601),
  ),
  Team(
    teamId: 93,
    teamName: 'Boston Red Sox',
    arenaName: 'Fenway Park',
    arenaLocation: 'Boston, Massachusetts',
    state: 'Massachusetts',
    logoPath: 'lib/assets/leagues/mlb/redsox.svg',
    abbName: 'BOS',
    leagueId: 4,
    color: const Color(0xFFBD3039),
  ),
  Team(
    teamId: 94,
    teamName: 'Chicago White Sox',
    arenaName: 'Guaranteed Rate Field',
    arenaLocation: 'Chicago, Illinois',
    state: 'Illinois',
    logoPath: 'lib/assets/leagues/mlb/whitesox.svg',
    abbName: 'CWS',
    leagueId: 4,
    color: const Color(0xFF000000),
  ),
  Team(
    teamId: 95,
    teamName: 'Chicago Cubs',
    arenaName: 'Wrigley Field',
    arenaLocation: 'Chicago, Illinois',
    state: 'Illinois',
    logoPath: 'lib/assets/leagues/mlb/cubs.svg',
    abbName: 'CHC',
    leagueId: 4,
    color: const Color(0xFF0E3386),
  ),
  Team(
    teamId: 96,
    teamName: 'Cincinnati Reds',
    arenaName: 'Great American Ball Park',
    arenaLocation: 'Cincinnati, Ohio',
    state: 'Ohio',
    logoPath: 'lib/assets/leagues/mlb/reds.svg',
    abbName: 'CIN',
    leagueId: 4,
    color: const Color(0xFFC6011F),
  ),
  Team(
    teamId: 97,
    teamName: 'Cleveland Guardians',
    arenaName: 'Progressive Field',
    arenaLocation: 'Cleveland, Ohio',
    state: 'Ohio',
    logoPath: 'lib/assets/leagues/mlb/guardians.svg',
    abbName: 'CLE',
    leagueId: 4,
    color: const Color(0xFF0C2340),
  ),
  Team(
    teamId: 98,
    teamName: 'Colorado Rockies',
    arenaName: 'Coors Field',
    arenaLocation: 'Denver, Colorado',
    state: 'Colorado',
    logoPath: 'lib/assets/leagues/mlb/rockies.svg',
    abbName: 'COL',
    leagueId: 4,
    color: const Color(0xFF33006F),
  ),
  Team(
    teamId: 99,
    teamName: 'Detroit Tigers',
    arenaName: 'Comerica Park',
    arenaLocation: 'Detroit, Michigan',
    state: 'Michigan',
    logoPath: 'lib/assets/leagues/mlb/tigers.svg',
    abbName: 'DET',
    leagueId: 4,
    color: const Color(0xFF0C2340),
  ),
  Team(
    teamId: 100,
    teamName: 'Houston Astros',
    arenaName: 'Minute Maid Park',
    arenaLocation: 'Houston, Texas',
    state: 'Texas',
    logoPath: 'lib/assets/leagues/mlb/astros.svg',
    abbName: 'HOU',
    leagueId: 4,
    color: const Color(0xFFEB6E1F),
  ),
  Team(
    teamId: 101,
    teamName: 'Kansas City Royals',
    arenaName: 'Kauffman Stadium',
    arenaLocation: 'Kansas City, Missouri',
    state: 'Missouri',
    logoPath: 'lib/assets/leagues/mlb/royals.svg',
    abbName: 'KC',
    leagueId: 4,
    color: const Color(0xFF004687),
  ),
  Team(
    teamId: 102,
    teamName: 'Los Angeles Angels',
    arenaName: 'Angel Stadium of Anaheim',
    arenaLocation: 'Anaheim, California',
    state: 'California',
    logoPath: 'lib/assets/leagues/mlb/angels.svg',
    abbName: 'LAA',
    leagueId: 4,
    color: const Color(0xFFBA0021),
  ),
  Team(
    teamId: 103,
    teamName: 'Los Angeles Dodgers',
    arenaName: 'Dodger Stadium',
    arenaLocation: 'Los Angeles, California',
    state: 'California',
    logoPath: 'lib/assets/leagues/mlb/dodgers.svg',
    abbName: 'LAD',
    leagueId: 4,
    color: const Color(0xFF005A9C),
  ),
  Team(
    teamId: 104,
    teamName: 'Miami Marlins',
    arenaName: 'loanDepot park',
    arenaLocation: 'Miami, Florida',
    state: 'Florida',
    logoPath: 'lib/assets/leagues/mlb/marlins.svg',
    abbName: 'MIA',
    leagueId: 4,
    color: const Color(0xFF00A3E0),
  ),
  Team(
    teamId: 105,
    teamName: 'Milwaukee Brewers',
    arenaName: 'American Family Field',
    arenaLocation: 'Milwaukee, Wisconsin',
    state: 'Wisconsin',
    logoPath: 'lib/assets/leagues/mlb/brewers.svg',
    abbName: 'MIL',
    leagueId: 4,
    color: const Color(0xFF0A2351),
  ),
  Team(
    teamId: 106,
    teamName: 'Minnesota Twins',
    arenaName: 'Target Field',
    arenaLocation: 'Minneapolis, Minnesota',
    state: 'Minnesota',
    logoPath: 'lib/assets/leagues/mlb/twins.svg',
    abbName: 'MIN',
    leagueId: 4,
    color: const Color(0xFF002B5C),
  ),
  Team(
    teamId: 107,
    teamName: 'New York Yankees',
    arenaName: 'Yankee Stadium',
    arenaLocation: 'Bronx, New York',
    state: 'New York',
    logoPath: 'lib/assets/leagues/mlb/yankees.svg',
    abbName: 'NYY',
    leagueId: 4,
    color: const Color(0xFF003087),
  ),
  Team(
    teamId: 108,
    teamName: 'New York Mets',
    arenaName: 'Citi Field',
    arenaLocation: 'Queens, New York',
    state: 'New York',
    logoPath: 'lib/assets/leagues/mlb/mets.svg',
    abbName: 'NYM',
    leagueId: 4,
    color: const Color(0xFF002D72),
  ),
  Team(
    teamId: 109,
    teamName: 'Oakland Athletics',
    arenaName: 'Oakland Coliseum',
    arenaLocation: 'Oakland, California',
    state: 'California',
    logoPath: 'lib/assets/leagues/mlb/athletics.svg',
    abbName: 'OAK',
    leagueId: 4,
    color: const Color(0xFF003831),
  ),
  Team(
    teamId: 110,
    teamName: 'Philadelphia Phillies',
    arenaName: 'Citizens Bank Park',
    arenaLocation: 'Philadelphia, Pennsylvania',
    state: 'Pennsylvania',
    logoPath: 'lib/assets/leagues/mlb/phillies.svg',
    abbName: 'PHI',
    leagueId: 4,
    color: const Color(0xFFE81828),
  ),
  Team(
    teamId: 111,
    teamName: 'Pittsburgh Pirates',
    arenaName: 'PNC Park',
    arenaLocation: 'Pittsburgh, Pennsylvania',
    state: 'Pennsylvania',
    logoPath: 'lib/assets/leagues/mlb/pirates.svg',
    abbName: 'PIT',
    leagueId: 4,
    color: const Color(0xFFFFCE0A),
  ),
  Team(
    teamId: 112,
    teamName: 'San Diego Padres',
    arenaName: 'Petco Park',
    arenaLocation: 'San Diego, California',
    state: 'California',
    logoPath: 'lib/assets/leagues/mlb/padres.svg',
    abbName: 'SD',
    leagueId: 4,
    color: const Color(0xFF2F241D),
  ),
  Team(
    teamId: 113,
    teamName: 'San Francisco Giants',
    arenaName: 'Oracle Park',
    arenaLocation: 'San Francisco, California',
    state: 'California',
    logoPath: 'lib/assets/leagues/mlb/giants.svg',
    abbName: 'SF',
    leagueId: 4,
    color: const Color(0xFFFD5A1E),
  ),
  Team(
    teamId: 114,
    teamName: 'Seattle Mariners',
    arenaName: 'T-Mobile Park',
    arenaLocation: 'Seattle, Washington',
    state: 'Washington',
    logoPath: 'lib/assets/leagues/mlb/mariners.svg',
    abbName: 'SEA',
    leagueId: 4,
    color: const Color(0xFF005C5C),
  ),
  Team(
    teamId: 115,
    teamName: 'St. Louis Cardinals',
    arenaName: 'Busch Stadium',
    arenaLocation: 'St. Louis, Missouri',
    state: 'Missouri',
    logoPath: 'lib/assets/leagues/mlb/cardinals.svg',
    abbName: 'STL',
    leagueId: 4,
    color: const Color(0xFFC41E3A),
  ),
  Team(
    teamId: 116,
    teamName: 'Tampa Bay Rays',
    arenaName: 'Tropicana Field',
    arenaLocation: 'St. Petersburg, Florida',
    state: 'Florida',
    logoPath: 'lib/assets/leagues/mlb/rays.svg',
    abbName: 'TB',
    leagueId: 4,
    color: const Color(0xFF092C5C),
  ),
  Team(
    teamId: 117,
    teamName: 'Texas Rangers',
    arenaName: 'Globe Life Field',
    arenaLocation: 'Arlington, Texas',
    state: 'Texas',
    logoPath: 'lib/assets/leagues/mlb/rangers.svg',
    abbName: 'TEX',
    leagueId: 4,
    color: const Color(0xFFC0111F),
  ),
  Team(
    teamId: 118,
    teamName: 'Toronto Blue Jays',
    arenaName: 'Rogers Centre',
    arenaLocation: 'Toronto, Ontario',
    state: 'Ontario',
    logoPath: 'lib/assets/leagues/mlb/bluejays.svg',
    abbName: 'TOR',
    leagueId: 4,
    color: const Color(0xFF134A8E),
  ),
  Team(
    teamId: 119,
    teamName: 'Washington Nationals',
    arenaName: 'Nationals Park',
    arenaLocation: 'Washington, D.C.',
    state: 'Washington, D.C.',
    logoPath: 'lib/assets/leagues/mlb/nationals.svg',
    abbName: 'WSH',
    leagueId: 4,
    color: const Color(0xFFAB0003),
  ),
];
