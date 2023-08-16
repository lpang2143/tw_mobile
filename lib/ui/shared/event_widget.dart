import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tw_mobile/data/classes/event.dart';
import 'package:tw_mobile/ui/pages/event_page/event_page.dart';
import 'package:tw_mobile/ui/pages/transfer_tickets_page/transfer_tickets_page.dart';
import 'package:tw_mobile/data/classes/ticket.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tw_mobile/ui/shared/ticket_dialog.dart';

enum EventType { owned, unowned }

class EventWidget extends StatefulWidget {
  final List<Event> eventList;
  final List<Ticket> ticketList;
  final String filter;
  final EventType eventType;

  const EventWidget({
    required this.eventList,
    this.ticketList = const [],
    required this.filter,
    required this.eventType,
  });

  @override
  State<EventWidget> createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  List<SeatObject> selectedSeats = [];

  void updateSelectedSeats(int index, List<SeatObject> seats) {
    setState(() {
      seats[index].selected = !seats[index].selected;
      debugPrint("Changed Seat ${seats[index].seatNumber}");
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Event> filteredEvents;

    if (widget.eventType == EventType.unowned) {
      filteredEvents = widget.eventList
          .where((event) =>
              event.getLeagueById(event.leagueId).getAbbreviation() ==
              widget.filter)
          .toList();
    } else {
      filteredEvents = widget.eventList
          .where((event) =>
              event.homeTeam.teamName.contains(widget.filter) ||
              event.awayTeam.teamName.contains(widget.filter))
          .toList();
    }
    filteredEvents.sort((a, b) => a.date.compareTo(b.date));

    if (widget.eventType == EventType.unowned) {
      return GestureDetector(
        onHorizontalDragUpdate: (details) {
          Scrollable.ensureVisible(
            context,
            alignment: 0.0,
            duration: const Duration(milliseconds: 250),
          );
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: filteredEvents
                .map((data) => Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: EventButton(
                          event: data,
                          eventType: widget.eventType,
                          tappable: true,
                          selectedSeats: mapTicketsToSeats(getTicketsByEventId(
                              widget.ticketList, data.eventId)),
                          updateSeats: updateSelectedSeats),
                    ))
                .toList(),
          ),
        ),
      );
    } else {
      return Wrap(
        alignment: WrapAlignment.start,
        spacing: 5.0,
        runSpacing: 5.0,
        children: filteredEvents
            .map((data) => EventButton(
                event: data,
                eventType: widget.eventType,
                tappable: true,
                selectedSeats: mapTicketsToSeats(
                    getTicketsByEventId(widget.ticketList, data.eventId)),
                updateSeats: updateSelectedSeats))
            .toList(),
      );
    }
  }
}

class EventButton extends StatelessWidget {
  final Event event;
  final EventType eventType;
  final bool tappable;
  final List<SeatObject> selectedSeats;
  final Function(int index, List<SeatObject> seats) updateSeats;

  const EventButton(
      {required this.event,
      required this.eventType,
      required this.tappable,
      required this.selectedSeats,
      required this.updateSeats});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (tappable) {
          if (eventType == EventType.owned) {
            _handleTicketTap(
                context, event, eventType, updateSeats, selectedSeats);
          } else {
            _handleSportTap(context, event);
          }
        }
      },
      child: _buildEventButton(context),
    );
  }

  Widget _buildEventButton(BuildContext context) {
    return Container(
      height: 180,
      width: 190,
      padding: const EdgeInsets.all(2.0),
      child: Stack(
        children: [
          _buildOutlineContainer(event.awayTeam.color, event.homeTeam.color),
          _buildInnerContainer(),
          ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              Center(child: _buildDateTimeRow(context)),
              const SizedBox(height: 15),
              _buildLogoRow(),
              const SizedBox(height: 15),
              _buildTeamText(event.awayTeam.teamName, true),
              _buildTeamText('At ${event.homeTeam.teamName}', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOutlineContainer(Color left, Color right) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: left.withOpacity(0.3),
            blurRadius: 1,
            spreadRadius: 1,
            offset: const Offset(-2, -2), // Top-left side glow
          ),
          BoxShadow(
            color: right.withOpacity(0.3),
            blurRadius: 1,
            spreadRadius: 1,
            offset: const Offset(2, -2), // Top-right side glow
          ),
          BoxShadow(
            color: left.withOpacity(0.3),
            blurRadius: 1,
            spreadRadius: 1,
            offset: const Offset(-2, 2), // Bottom-left side glow
          ),
          BoxShadow(
            color: right.withOpacity(0.3),
            blurRadius: 1,
            spreadRadius: 1,
            offset: const Offset(2, 2), // Bottom-right side glow
          ),
        ],
        gradient: LinearGradient(
          colors: [left, right],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }

  Widget _buildInnerContainer() {
    return Container(
      margin: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        color: Colors.white,
      ),
    );
  }

  void _handleTicketTap(
    BuildContext context,
    Event event,
    EventType eventType,
    void Function(int, List<SeatObject>) updateSeats,
    List<SeatObject> selectedSeats,
  ) {
    showDialog(
      context: context,
      barrierColor: Colors.white.withOpacity(0.87),
      builder: (context) => TicketDialog(
        event: event,
        eventType: eventType,
        updateSeats: updateSeats,
        selectedSeats: selectedSeats,
      ),
    );
  }

  void _handleSportTap(BuildContext context, Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventPage(event: event),
      ),
    );
  }

// Builds the date and time row for the event.
//
// Returns: Widget containing the date and time information.
  Widget _buildDateTimeRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        '${DateFormat.MMM().format(event.parsedDate).toUpperCase()} ${event.parsedDate.day} | ${event.parsedTime.format(context)}',
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

// Builds the row with two overlapping logo circles.
//
// Returns: Widget containing the row of logo circles.
  Widget _buildLogoRow() {
    return SizedBox(
      height: 80,
      child: Stack(
        children: [
          Positioned(
            left: 20,
            child:
                _buildLogoCircle(event.awayTeam.color, event.awayTeam.logoPath),
          ),
          Positioned(
            right: 20,
            child:
                _buildLogoCircle(event.homeTeam.color, event.homeTeam.logoPath),
          ),
        ],
      ),
    );
  }

// Builds a circular container for the logo.
//
// Returns: Widget representing the logo circle.
  Widget _buildLogoCircle(Color color, String logoPath) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 3,
            spreadRadius: 2,
          ),
        ],
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(logoPath, fit: BoxFit.contain),
      ),
    );
  }

// Builds the text widget for the team name.
//
// Returns: Widget containing the team name text.
  Widget _buildTeamText(String text, bool isAway) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: isAway ? 16 : 12,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w700,
          color: Colors.black),
    );
  }
}
