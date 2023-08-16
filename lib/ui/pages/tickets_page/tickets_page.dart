import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tw_mobile/data/classes/team.dart';
import 'package:tw_mobile/ui/pages/upload/upload_page.dart';
import 'package:tw_mobile/data/classes/event.dart';
import 'package:tw_mobile/services/api_client.dart';
import 'package:tw_mobile/ui/shared/sports_icon.dart';
import 'package:tw_mobile/ui/shared/event_widget.dart';
import 'package:tw_mobile/data/classes/ticket.dart';
import 'package:tw_mobile/ui/shared/globals.dart';

class MyTicketsPage extends StatefulWidget {
  @override
  MyTicketsPageState createState() => MyTicketsPageState();
}

class MyTicketsPageState extends State<MyTicketsPage> with RouteAware {
  String selectedTeam = '';
  List<SportData> teamList = [];
  List<Event> eventList = [];
  List<Ticket> ticketList = [];
  int teamIndex = 0;

  late final Future<void> fetchDataFuture;

  final apiClient =
      ApiClient(); // Replace with your actual API client instantiation in prod
  final int numberOfLeagues = 6;

  @override
  void initState() {
    super.initState();
    fetchDataFuture = _fetchData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute<dynamic>);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _fetchData();
  }

  void _fetchUserEvents() async {
    try {
      var events = await apiClient.getUserEvents();
      List<SportData> teams = getHomeTeams(events);

      setState(() {
        eventList = events;
        teamList = teams;
        selectedTeam = teamList[teamIndex].label;
      });
    } catch (e) {
      // handle exception
    }
  }

  void _fetchUserTickets() async {
    try {
      var tickets = await apiClient.getUserTickets();
      setState(() {
        ticketList = tickets;
      });
    } catch (e) {
      // handle exception
    }
  }

  Future<void> _fetchData() async {
    _fetchUserEvents();
    _fetchUserTickets();
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

  void updatedSelectedTeam(String team) {
    setState(() {
      selectedTeam = team;
      teamIndex =
          teamList.indexWhere((element) => element.label == selectedTeam);
      debugPrint('$teamIndex');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            FutureBuilder(
              future: fetchDataFuture,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return ListView(
                    children: [
                      _MyTicketsText(),
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
                        child: EventWidget(
                            ticketList: ticketList,
                            eventList: eventList,
                            filter: selectedTeam,
                            eventType: EventType.owned),
                      ),
                    ],
                  );
                }
              },
            ),
            _uploadButton(context),
          ],
        ),
      ),
    );
  }

  Positioned _uploadButton(BuildContext context) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => UploadPage()));
        },
        child: const Icon(Icons.upload),
      ),
    );
  }
}

class _MyTicketsText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'lib/assets/title_banner.png',
          width: double.infinity,
          fit: BoxFit.fill,
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'My Tickets',
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
