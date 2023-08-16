import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tw_mobile/data/classes/event.dart';
import 'package:tw_mobile/data/classes/team.dart';
import 'package:tw_mobile/services/api_client.dart';
import 'package:tw_mobile/ui/shared/sell_ticket_widget.dart';
import 'package:tw_mobile/ui/shared/sports_icon.dart';
import 'package:tw_mobile/data/classes/ticket.dart';

class ListTicketsPage extends StatefulWidget {
  @override
  ListTicketsPageState createState() => ListTicketsPageState();
}

class ListTicketsPageState extends State<ListTicketsPage> {
  ApiClient apiClient = ApiClient();
  Future<List<Event>> eventListing = Future(() => []);
  String selectedTeam = '';
  bool reset = false;
  List<bool> selling = [];
  List<bool> selectedSeats = [];
  final int numberOfLeagues = 6;
  List<SportData> teamList = [];

  @override
  void initState() {
    super.initState();
    _setUserEvents();
  }

  void _setUserEvents() async {
    try {
      var events = fetchUserEvents();
      var eventsAsList = await events;
      List<SportData> teams = getHomeTeams(eventsAsList);

      setState(() {
        eventListing = events;
        teamList = teams;
        selectedTeam = teamList[0].label;
        selling = List<bool>.filled(eventsAsList.length, false);
      });
    } catch (e) {
      // handle error
    }
  }

  Future<List<Event>> fetchUserEvents() async {
    return await apiClient.getUserEvents();
  }

  List<SportData> getHomeTeams(List<Event> eventList) {
    List<Team> homeTeams = [];
    List<SportData> teams = [];

    for (int i = 0; i < eventList.length; i++) {
      Team newTeam = eventList[i].getTeamById(eventList[i].homeTeamId,
          leagueId: eventList[i].leagueId);

      bool alreadyExists =
          homeTeams.any((team) => team.teamId == newTeam.teamId);

      if (!alreadyExists) {
        homeTeams.add(newTeam);
      }
    }

    for (int i = 0; i < homeTeams.length; i++) {
      teams.add(SportData(
        label: homeTeams[i].teamName,
        logo: SvgPicture.asset(
          homeTeams[i].logoPath,
        ),
      ));
    }
    return teams;
  }

  void updatedSelectedTeam(String sport) {
    setState(() {
      selectedTeam = sport;
      reset = true;
      selling = List.filled(selling.length, false);
    });
  }

  void updateSelectedSeats(int index) {
    setState(() {
      selectedSeats[index] = !selectedSeats[index];
      debugPrint("Changed Seat ${index + 1}");
    });
  }

  void updateSelectedTicket(int index) {
    setState(() {
      selling[index] = !selling[index];
      // if (selling[index]) {
      //   reset = false;
      // } else {
      //   reset = true;
      // }

      debugPrint("changed: ${index}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              children: [
                _TopRowBanner(),
                const SizedBox(height: 12),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: SportsIcons(
                      sportsData: teamList,
                      updateFunction: updatedSelectedTeam,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: FutureBuilder(
                    future: eventListing,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.data != null) {
                          return SellTicketWidget(
                            ticketList: snapshot.data,
                            team: selectedTeam,
                            reset: reset,
                            updateTickets: updateSelectedTicket,
                            selling: selling,
                            updateSeats: updateSelectedSeats,
                            selectedSeats: selectedSeats,
                          );
                        } else {
                          return const SizedBox();
                        }
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                ),
                const SizedBox(height: 200),
              ],
            ),
            selling.contains(true)
                ? _showSellButton(selling)
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _showSellButton(List<bool> selling) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Container(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(23, 182, 20, 1),
                  blurRadius: 20,
                  spreadRadius: 1,
                ),
              ]),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              shadowColor: const Color.fromRGBO(23, 182, 20, 1),
              backgroundColor: Colors.white,
              foregroundColor: Colors.transparent,
            ),
            onPressed: () {
              debugPrint(selling.toString());
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
              child: Text("SELL",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: const Color.fromRGBO(35, 178, 153, 1),
                      fontSize: 30)),
            ),
          ),
        ),
      ),
    );
  }

  Positioned _uploadButton() {
    return Positioned(
      bottom: 16,
      right: 16,
      child: FloatingActionButton(
        onPressed: () {
          // TODO: Handle upload button tap
        },
        child: const Icon(Icons.upload),
      ),
    );
  }
}

class _TopRowBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'lib/assets/title_banner.png',
          fit: BoxFit.fill,
          width: double.infinity,
        ),
        Positioned.fill(
          left: 0,
          child: Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Sell Tickets',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
      ],
    );
  }
}
