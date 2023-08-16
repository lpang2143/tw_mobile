import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tw_mobile/data/classes/event.dart';
import 'package:tw_mobile/data/classes/ticket.dart';
import 'package:tw_mobile/ui/shared/select_seats_popup.dart';

class SellTicketWidget extends StatefulWidget {
  final List<Event>? ticketList;
  final String team;
  bool reset;
  final void Function(int index) updateTickets;
  List<bool> selling;
  final void Function(int index) updateSeats;
  final List<bool> selectedSeats;

  SellTicketWidget({
    required this.ticketList,
    required this.team,
    required this.reset,
    required this.updateTickets,
    required this.selling,
    required this.updateSeats,
    required this.selectedSeats,
  });

  @override
  State<SellTicketWidget> createState() => _SellTicketWidgetState();
}

class _SellTicketWidgetState extends State<SellTicketWidget> {
  late int len = widget.ticketList!.length;
  late List<bool> isFlipped = List<bool>.filled(len, true);

  @override
  Widget build(BuildContext context) {
    final filteredEvents = widget.ticketList!
        .where((event) =>
            event.homeTeam.teamName.contains(widget.team) ||
            event.awayTeam.teamName.contains(widget.team))
        .toList();

    filteredEvents.sort((a, b) => a.date.compareTo(b.date));
    void onPressed(int index) => setState(
          () {
            int reFlip = isFlipped.indexOf(false);

            // if (reFlip != index && reFlip != -1) {
            //   isFlipped[reFlip] = !isFlipped[reFlip];
            // }
            isFlipped[index] = !isFlipped[index];
          },
        );
    if (widget.reset) {
      isFlipped = List<bool>.filled(filteredEvents.length, true);
      debugPrint("reset");
      widget.reset = false;
      return _createTicketRows(
          filteredEvents,
          isFlipped,
          onPressed,
          true,
          widget.updateTickets,
          widget.selling,
          widget.updateSeats,
          widget.selectedSeats);
    } else {
      return _createTicketRows(
          filteredEvents,
          isFlipped,
          onPressed,
          false,
          widget.updateTickets,
          widget.selling,
          widget.updateSeats,
          widget.selectedSeats);
    }
  }

  Wrap _createTicketRows(
    List<Event> filteredEvents,
    List<bool> isFlipped,
    void Function(int index) onPressed,
    bool reset,
    void Function(int index) updateTickets,
    List<bool> selling,
    void Function(int index) updateSeats,
    List<bool> selectedSeats,
  ) {
    return Wrap(
      spacing: 5.0,
      runSpacing: 5.0,
      children: filteredEvents.map((data) {
        int index = filteredEvents.indexOf(data);
        if (reset) {
          return TicketButton(
            event: data,
            flipped: isFlipped[index],
            index: index,
            onPressed: onPressed,
            reset: reset,
            updateTickets: updateTickets,
            selling: selling,
            updateSeats: updateSeats,
            selectedSeats: selectedSeats,
          );
        } else {
          return TicketButton(
            event: data,
            flipped: isFlipped[index],
            index: index,
            onPressed: onPressed,
            reset: reset,
            updateTickets: updateTickets,
            selling: selling,
            updateSeats: updateSeats,
            selectedSeats: selectedSeats,
          );
        }
      }).toList(),
    );
  }
}

class TicketButton extends StatelessWidget {
  final Event event;
  final bool flipped;
  final int index;
  final void Function(int index) onPressed;
  final bool reset;
  final void Function(int index) updateTickets;
  final List<bool> selling;
  final void Function(int index) updateSeats;
  final List<bool> selectedSeats;

  const TicketButton({
    required this.event,
    required this.flipped,
    required this.index,
    required this.onPressed,
    required this.reset,
    required this.updateTickets,
    required this.selling,
    required this.updateSeats,
    required this.selectedSeats,
  });

  @override
  Widget build(BuildContext context) {
    int animationTimer;
    if (!selling[index]) {
      if (reset) {
        animationTimer = 0;
      } else {
        animationTimer = 500;
      }
      return GestureDetector(
        onTap: () {
          onPressed(index);
        },
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: animationTimer),
          reverseDuration: Duration(milliseconds: animationTimer),
          switchInCurve: Curves.ease,
          switchOutCurve: Curves.ease,
          transitionBuilder: transition,
          child: flipped
              ? _buildFront(context)
              : _buildBack(context, updateTickets, index, updateSeats,
                  selectedSeats, event),
        ),
      );
    } else {
      return _buildSelectedTicket(context, updateTickets, index);
    }
  }

  Widget _buildFront(BuildContext context) {
    return Container(
      key: const Key('first'),
      height: 180,
      width: 190,
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          _buildOutlineContainer(event.awayTeam.color, event.homeTeam.color),
          _buildInnerContainer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildDateTimeRow(context),
              const SizedBox(height: 4),
              _buildLogoRow(),
              const SizedBox(height: 6),
              _buildTeamText(event.awayTeam.teamName, true),
              _buildTeamText('At ${event.homeTeam.teamName}', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBack(
    BuildContext context,
    void Function(int index) updateTickets,
    int index,
    void Function(int index) updateSeats,
    List<bool> selectedSeats,
    Event event,
  ) {
    return Container(
      key: const Key('second'),
      height: 180,
      width: 190,
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildOutlineContainer(Colors.green, Colors.green),
          _buildInnerContainer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(35, 178, 153, 1),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ]),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      shadowColor: const Color.fromRGBO(35, 178, 153, 1),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.transparent,
                    ),
                    onPressed: () {
                      updateTickets(index);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "SELL ALL",
                        style: TextStyle(
                          color: Color.fromRGBO(35, 178, 153, 1),
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(35, 178, 153, 1),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ]),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      shadowColor: const Color.fromRGBO(35, 178, 153, 1),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.transparent,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (BuildContext context, _, __) =>
                              SelectSeatsPopup(
                                  updateSeats: updateSeats,
                                  selectedSeats: selectedSeats,
                                  updateTickets: updateTickets,
                                  ticketNumber: index,
                                  event: event),
                        ),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "SELECT",
                        style: TextStyle(
                          color: Color.fromRGBO(35, 178, 153, 1),
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedTicket(
      BuildContext context, void Function(int index) updateTickets, int index) {
    return Container(
      height: 180,
      width: 190,
      child: Transform.scale(
        scale: 0.75,
        child: Stack(
          children: [
            _buildOutlineContainer(Colors.green, Colors.green),
            _buildInnerContainer(),
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FittedBox(child: _buildDateTimeRow(context)),
                  _buildLogoRow(),
                  const SizedBox(height: 8),
                  FittedBox(
                      child: _buildTeamText(event.awayTeam.teamName, true)),
                  FittedBox(
                      child: _buildTeamText(
                          'At ${event.homeTeam.teamName}', false)),
                ],
              ),
            ),
            IconButton(
                onPressed: () {
                  updateTickets(index);
                },
                icon: const Icon(
                  Icons.check_box_rounded,
                  color: Colors.green,
                )),
          ],
        ),
      ),
    );
  }

  Widget transition(Widget widget, Animation<double> animation) {
    final flipAnimation = Tween(begin: pi, end: 0.0).animate(animation);

    return AnimatedBuilder(
      animation: flipAnimation,
      child: widget,
      builder: (conext, widget) {
        final isUnder = (ValueKey(flipped) != widget?.key);
        final value =
            isUnder ? min(flipAnimation.value, pi / 2) : flipAnimation.value;
        return Transform(
          transform: Matrix4.rotationY(value),
          alignment: Alignment.center,
          child: widget,
        );
      },
    );
  }

  Widget _buildOutlineContainer(Color left, Color right) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: left.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(-2, -2), // Top-left side glow
          ),
          BoxShadow(
            color: right.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(2, -2), // Top-right side glow
          ),
          BoxShadow(
            color: left.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(-2, 2), // Bottom-left side glow
          ),
          BoxShadow(
            color: right.withOpacity(0.3),
            blurRadius: 5,
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
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
    );
  }

  // void _handleTap(BuildContext context) {
  //   setState(() {
  //     isFlipped = !isFlipped;
  //   });
  // }

  Widget _buildButtonColumn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButton(
          context,
          'TRANSFER',
          Colors.blue,
          () {
            // Handle Transfer button tap
            // TODO: Add logic here
            debugPrint('Transfer button tapped!');
            Navigator.pop(context); // Close the dialog
          },
        ),
        _buildButton(
          context,
          'SCAN',
          Colors.purple,
          () {
            // Handle Scan button tap
            // TODO: Add logic here
            debugPrint('Scan button tapped!');
            Navigator.pop(context); // Close the dialog
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(DateFormat.MMM().format(event.parsedDate),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                Text(event.parsedDate.day.toString(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
              ],
            ),
            const SizedBox(
              width: 20,
            ),
            Container(
              height: 40,
              width: 2,
              color: Colors.black,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.awayTeam.teamName,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                Text('At ${event.homeTeam}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        )),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButton(
    BuildContext context,
    String buttonText,
    Color textColor,
    VoidCallback onPressed,
  ) {
    return Container(
      height: 90,
      width: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: textColor
                .withOpacity(0.4), // Adjust the opacity for the glow effect
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
        color: Colors.white,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(15),
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          buttonText,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: textColor,
              ),
        ),
      ),
    );
  }

  // Builds the date and time row for the event.
  Widget _buildDateTimeRow(BuildContext context) {
    return Text(
      '${DateFormat.MMM().format(event.parsedDate).toUpperCase()} ${event.parsedDate.day} | ${event.parsedTime.format(context)}',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  // Builds the row with two overlapping logo circles.
  Widget _buildLogoRow() {
    return SizedBox(
      height: 80,
      child: Stack(
        children: [
          Positioned(
            left: 15,
            child:
                _buildLogoCircle(event.awayTeam.color, event.awayTeam.logoPath),
          ),
          Positioned(
            right: 15,
            child:
                _buildLogoCircle(event.homeTeam.color, event.homeTeam.logoPath),
          ),
        ],
      ),
    );
  }

  // Builds a circular container for the logo.
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
  Widget _buildTeamText(String text, bool isAway) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: isAway ? 14 : 12,
        fontWeight: FontWeight.bold,
        color: isAway ? Colors.black : Colors.grey,
      ),
    );
  }
}
