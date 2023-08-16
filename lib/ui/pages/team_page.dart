import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tw_mobile/data/classes/team.dart';
import 'package:tw_mobile/data/classes/event.dart';
import 'package:tw_mobile/services/api_client.dart';
import 'package:tw_mobile/ui/pages/event_page/event_page.dart';

class TeamPage extends StatefulWidget {
  final Team team;

  TeamPage({required this.team});

  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  String filter = "Home";
  List<Event> eventList = [];
  ApiClient apiClient = ApiClient();

  @override
  void initState() {
    super.initState();
    getEventList();
  }

  void getEventList() async {
    int teamId = widget.team.teamId;
    List<Event> events = await apiClient.getTeamEvents(teamId);

    setState(() {
      eventList = events;
    });
  }

  List<Event> filterList(List<Event> eventList, String filter) {
    if (filter == "Home") {
      return eventList
          .where((event) => event.homeTeamId == widget.team.teamId)
          .toList();
    } else if (filter == "Away") {
      return eventList
          .where((event) => event.awayTeamId == widget.team.teamId)
          .toList();
    } else {
      // Return the unfiltered list if the filter doesn't match "Home" or "Away"
      return eventList;
    }
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets mediaPadding = MediaQuery.of(context).padding;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.only(top: mediaPadding.top),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SvgPicture.asset(
                widget.team.logoPath,
                width: 75,
                height: 75,
              ),
            ),
            const SizedBox(height: 15),
            Stack(
              children: [
                Placeholder(
                  fallbackHeight: 200,
                  fallbackWidth: MediaQuery.of(context).size.width,
                ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: Text(
                    widget.team.teamName,
                    style: TextStyle(
                      fontSize: 30,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 2
                        ..color = Colors.black,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: Text(
                    widget.team.teamName,
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SelectorButton(
                  text: "Home",
                  isSelected: filter == "Home",
                  onTap: () => setState(() => filter = "Home"),
                ),
                SelectorButton(
                  text: "Away",
                  isSelected: filter == "Away",
                  onTap: () => setState(() => filter = "Away"),
                ),
                SelectorButton(
                  text: "Parking",
                  isSelected: filter == "Parking",
                  onTap: () => setState(() => filter = "Parking"),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            _buildEvents()
          ],
        ),
      ),
    );
  }

  Expanded _buildEvents() {
    return Expanded(
      child: ListView.separated(
        itemCount: filterList(eventList, filter).length,
        separatorBuilder: (context, index) => const Divider(
          color: Colors.grey,
          thickness: 1,
        ),
        itemBuilder: (context, index) {
          final event = filterList(eventList, filter)[index];
          final weekday = event.dayOfWeek;
          final formattedDate =
              "${event.parsedDate.month.toString().padLeft(2, '0')}/${event.parsedDate.day.toString().padLeft(2, '0')}";
          final matchup =
              "${event.awayTeam.teamName} @ ${event.homeTeam.teamName}";

          return ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(formattedDate),
                Text(
                  weekday,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            title: Text(matchup),
            trailing: const Text(
              'Price',
              style: TextStyle(
                color: Colors.purple,
              ),
            ),
            onTap: () {
              debugPrint('Event no: ${event.eventId}');
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EventPage(event: event)),
              );
            },
          );
        },
      ),
    );
  }
}

class SelectorButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectorButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.purple : Colors.black,
              fontSize: 24,
            ),
          ),
          Container(
            width: 80, // adjust as needed
            height: 2,
            color: isSelected ? Colors.purple : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
