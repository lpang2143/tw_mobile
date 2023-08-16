import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:tw_mobile/data/classes/event.dart';
import 'package:tw_mobile/data/classes/ticket.dart';
import 'package:tw_mobile/ui/pages/transfer_tickets_page/transfer_tickets_page.dart';
import 'package:tw_mobile/ui/shared/event_widget.dart';
import 'package:intl/intl.dart';
import 'package:tw_mobile/ui/shared/scan_side.dart';

class TicketDialog extends StatefulWidget {
  final Event event;
  final EventType eventType;
  final void Function(int, List<SeatObject>) updateSeats;
  final List<SeatObject> selectedSeats;

  TicketDialog({
    required this.event,
    required this.eventType,
    required this.updateSeats,
    required this.selectedSeats,
  });

  @override
  _TicketDialogState createState() => _TicketDialogState();
}

class _TicketDialogState extends State<TicketDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _showFront = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {});
        if (_animation.value >= 0.5 && _showFront) {
          _showFront = false;
        } else if (_animation.value <= 0.5 && !_showFront) {
          _showFront = true;
        }
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.none,
      content: Stack(
        children: [
          Center(
            heightFactor: 1.2,
            child: SizedBox(
              width: 500,
              height: 500,
              child: _buildBody(context, widget.event, widget.eventType,
                  widget.updateSeats, widget.selectedSeats),
            ),
          ),
        ],
      ),
    );
  }

  Positioned _exitButton(BuildContext context) {
    return Positioned(
      right: 20,
      top: 10,
      child: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.close_sharp),
        iconSize: 40,
        color: Colors.black45,
      ),
    );
  }

  Positioned _flipButton() {
    return Positioned(
      top: 12,
      left: 20,
      child: IconButton(
        onPressed: () {
          _animationController.reverse();
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black45,
        ), // Use reverse arrow icon
        iconSize: 35,
      ),
    );
  }

  Widget _buildBody(
      BuildContext context,
      Event event,
      EventType eventType,
      void Function(int, List<SeatObject>) updateSeats,
      List<SeatObject> selectedSeats) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.002)
        ..rotateY(math.pi * _animation.value),
      child: _showFront
          ? _buildFront(
              context,
              event,
              eventType,
              updateSeats,
              selectedSeats,
            )
          : _buildBackSide(selectedSeats),
    );
  }

  Widget _buildBackSide(List<SeatObject> seats) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()..rotateY(math.pi),
      child: Stack(
        children: [
          Center(
            child: Positioned.fill(
              child: Image.asset(
                'lib/assets/ticketBackground.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Center(
            child: ScanSide(
              event: widget.event,
              seatObjects: seats,
            ),
          ),
          _exitButton(context),
          _flipButton()
        ],
      ),
    );
  }

  Widget _buildFront(
      BuildContext context,
      Event event,
      EventType eventType,
      void Function(int, List<SeatObject>) updateSeats,
      List<SeatObject> selectedSeats) {
    return Stack(children: [
      Center(
        child: Positioned.fill(
          child: Image.asset(
            'lib/assets/ticketBackground.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
      _exitButton(context),
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(height: 0),
          _buildButton(
            context,
            'TRANSFER',
            const Color(0xff6B95FF),
            () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => TransferTicketsPage(
                        event: event,
                        eventType: eventType,
                        selectedSeats: selectedSeats,
                        updateSeats: updateSeats,
                      )),
                ),
              );
            },
          ),
          _buildButton(
            context,
            'SCAN',
            const Color(0xff8640F9),
            () {
              if (_animationController.isCompleted) {
                _animationController.reverse();
              } else {
                _animationController.forward();
              }
            },
          ),
          _buildButton(
            context,
            'SELL',
            const Color(0xff23B299),
            () {
              // Handle Sell button tap
              // TODO: Add logic here
              debugPrint('Sell button tapped!');
              Navigator.pop(context); // Close the dialog
            },
          ),
          BuildBottomText(
            event: event,
          ),
        ],
      ),
    ]);
  }

  Widget _buildButton(
    BuildContext context,
    String buttonText,
    Color textColor,
    VoidCallback onPressed,
  ) {
    return Container(
      height: 70,
      width: 200,
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
}

class BuildBottomText extends StatelessWidget {
  Event event;

  BuildBottomText({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
            height: 50,
            width: 2,
            color: Colors.black,
          ),
          const SizedBox(
            width: 20,
          ),
          SizedBox(
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  child: Text(event.awayTeam.teamName,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                ),
                Text('At ${event.homeTeam.teamName}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
