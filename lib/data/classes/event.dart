import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:tw_mobile/classes/leagues/league_list.dart';
import 'package:tw_mobile/data/classes/league.dart';
import 'package:tw_mobile/data/classes/team.dart';

class Event {
  final int eventId;
  final String time;
  final String date;
  final String location;
  final double duration;
  final String eventType;
  final int eventOwnerId;
  final int awayTeamId;
  final int homeTeamId;
  final int leagueId;
  final int performerId;

  Event({
    required this.eventId,
    required this.time,
    required this.date,
    required this.location,
    required this.duration,
    required this.eventType,
    required this.eventOwnerId,
    required this.awayTeamId,
    required this.homeTeamId,
    required this.leagueId,
    required this.performerId,
  });

  Team get awayTeam {
    return getTeamById(awayTeamId, leagueId: leagueId);
  }

  Team get homeTeam {
    return getTeamById(homeTeamId, leagueId: leagueId);
  }

  DateTime get parsedDate {
    return parseDate(date);
  }

  TimeOfDay get parsedTime {
    return parseTimeOfDay(time);
  }

  String get dayOfWeek {
    return getDayOfWeek(parsedDate);
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventId: json['event_id'],
      time: json['time'],
      date: json['date'],
      location: json['location'],
      duration: json['duration'],
      eventType: json['event_type'],
      eventOwnerId: json['event_owner_id'] ?? 0,
      homeTeamId: json['home_team_id'],
      awayTeamId: json['away_team_id'],
      leagueId: json['league_id'],
      performerId: json['performer_id'] ?? 0,
    );
  }

  // USAGE:
  // List<dynamic> jsonList = jsonDecode(jsonListString);
  // List<Ticket> leagues = Ticket.fromJsonList(jsonList);
  static List<Event> fromJsonList(dynamic jsonData) {
    if (jsonData is List<dynamic>) {
      return jsonData.map((json) => Event.fromJson(json)).toList();
    } else if (jsonData is Map<String, dynamic>) {
      return [Event.fromJson(jsonData)];
    } else {
      throw Exception('Invalid JSON data');
    }
  }

  TimeOfDay parseTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    int hour = int.parse(parts[0]);
    final minutePart = parts[1].split(' ');

    final minute = int.parse(minutePart[0]);
    final isPM = minutePart[1].toUpperCase() == 'PM';

    if (isPM && hour != 12) {
      hour += 12;
    } else if (!isPM && hour == 12) {
      hour = 0;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  DateTime parseDate(String dateString) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    return dateFormat.parse(dateString);
  }

  String getFormattedDateTime() {
    DateTime parsedDate = parseDate(date);
    TimeOfDay parsedTime = parseTimeOfDay(time);
    final format = DateFormat.yMMMMd().add_jm();
    final dateTime = DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
      parsedTime.hour,
      parsedTime.minute,
    );
    return format.format(dateTime);
  }

  String getDayOfWeek(DateTime day) {
    return DateFormat('EEE').format(day);
  }

  League getLeagueById(int leagueId) {
    return leagueList.firstWhere((league) => league.leagueId == leagueId);
  }

  Team getTeamById(int teamId, {League? league, int? leagueId}) {
    if (league != null) {
      return league.teams!.firstWhere((team) => team.teamId == teamId);
    } else if (leagueId != null) {
      // Fetch the league using the leagueId (assuming you have a way to do that)
      League? fetchedLeague = getLeagueById(leagueId);
      return fetchedLeague.teams!.firstWhere((team) => team.teamId == teamId);
    }
    throw Exception('Team not found.');
  }
}
