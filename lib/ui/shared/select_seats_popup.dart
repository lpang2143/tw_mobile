import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tw_mobile/data/classes/event.dart';
import 'package:tw_mobile/data/classes/ticket.dart';
import 'package:tw_mobile/services/api_client.dart';

class SelectSeatsPopup extends StatefulWidget {
  final void Function(int index) updateSeats;
  final List<bool> selectedSeats;
  final void Function(int index) updateTickets;
  final int ticketNumber;
  final Event event;

  const SelectSeatsPopup({
    super.key,
    required this.updateSeats,
    required this.selectedSeats,
    required this.updateTickets,
    required this.ticketNumber,
    required this.event,
  });

  @override
  SelectSeatsPopupState createState() => SelectSeatsPopupState();
}

class SelectSeatsPopupState extends State<SelectSeatsPopup> {
  ApiClient apiClient = ApiClient();
  List<Ticket> userEventTickets = [];
  List<bool> selectedTickets = [];
  Future<List<Ticket>> futureTickets = Future(() => []);
  int userId = 1;
  @override
  void initState() {
    super.initState();
    _setUserTickets();
  }

  void _setUserTickets() async {
    try {
      var tickets = fetchUserTickets();
      var ticketsAsList = await tickets;

      setState(() {
        userEventTickets = ticketsAsList;
        futureTickets = tickets;
        selectedTickets = List<bool>.filled(userEventTickets.length, false);
        debugPrint(
            '${userEventTickets.length} tickets for event ${widget.event.eventId}');
      });
    } catch (e) {
      // handle error
    }
  }

  Future<List<Ticket>> fetchUserTickets() async {
    return await apiClient.getUserEventTicket(widget.event.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white70,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 0),
        child: Container(
          color: Theme.of(context)
              .colorScheme
              .background, // change background color
          child: Column(children: [
            const Align(
              alignment: Alignment.topRight,
              child: ExitButton(),
            ),
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Heading(event: widget.event),
                  const SizedBox(height: 10),
                  FutureBuilder(
                    future: futureTickets,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.data != null) {
                          return SizedBox(
                            height: 300,
                            child: ListView.builder(
                              padding: const EdgeInsets.only(top: 30),
                              shrinkWrap: true,
                              itemCount: selectedTickets.length,
                              itemBuilder: (context, index) {
                                final seating = selectedTickets[index];
                                return Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Seat(
                                        index: index,
                                        isSelected: seating,
                                        onPressed: () {
                                          setState(
                                            () {
                                              selectedTickets[index] =
                                                  !selectedTickets[index];
                                              // widget.updateSeats(index);
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  const PriceFloor(),
                  const SizedBox(height: 20),
                  SellButton(
                      updateTickets: widget.updateTickets,
                      ticketNumber: widget.ticketNumber),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class SellButton extends StatelessWidget {
  final void Function(int index) updateTickets;
  final int ticketNumber;
  const SellButton({
    super.key,
    required this.updateTickets,
    required this.ticketNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          updateTickets(ticketNumber);
          Navigator.of(context).pop();
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 80),
          child: Text(
            "Sell",
            style: TextStyle(
              color: Color.fromRGBO(35, 178, 153, 1),
              fontSize: 25,
            ),
          ),
        ),
      ),
    );
  }
}

class PriceFloor extends StatefulWidget {
  const PriceFloor({
    super.key,
  });

  @override
  State<PriceFloor> createState() => _PriceFloorState();
}

class _PriceFloorState extends State<PriceFloor> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Price Floor:',
              style: TextStyle(
                color: Color.fromRGBO(10, 17, 88, 1),
                fontSize: 20,
              ),
            ),
            Text(
              '(not recommended)',
              style: TextStyle(
                color: Color.fromRGBO(10, 17, 88, 0.72),
                fontSize: 10,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 50,
          width: 110,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: TextField(
              controller: _textEditingController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '\$0.00',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(10, 17, 88, 0.35),
                    fontSize: 20,
                  )),
              style: const TextStyle(color: Colors.black, fontSize: 20),
              onSubmitted: (value) {
                debugPrint('Entered value: $value');
              },
            ),
          ),
        ),
      ],
    );
  }
}

class ExitButton extends StatelessWidget {
  const ExitButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: const CircleBorder()),
      child: const Padding(
        padding: EdgeInsets.all(3.0),
        child: Icon(
          Icons.close_sharp,
          size: 50,
          color: Colors.black54,
        ),
      ),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}

class Seat extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isSelected;
  final int index;

  const Seat({
    super.key,
    required this.index,
    required this.onPressed,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor:
                isSelected ? const Color.fromRGBO(10, 17, 88, 1) : Colors.white,
          ),
          onPressed: onPressed,
          child: Row(
            children: [
              const Icon(
                Icons.check_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 72.5),
              Align(
                child: Text(
                  "Seat ${index + 1}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 22,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class Heading extends StatelessWidget {
  Event event;
  Heading({
    required this.event,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(35, 178, 153, 1),
                blurRadius: 7,
                spreadRadius: 1,
              ),
            ]),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
          child: IntrinsicHeight(
            child: Row(
              children: [
                ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxHeight: 80, maxWidth: 100),
                  child: Text(
                    '${DateFormat.MMM().format(event.parsedDate).toUpperCase()} \n ${event.parsedDate.day}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Color.fromRGBO(10, 17, 88, 1), fontSize: 30),
                  ),
                ),
                const SizedBox(width: 15),
                Container(
                  decoration: const BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(23, 182, 20, 0.2),
                      blurRadius: 7,
                      spreadRadius: 0.01,
                    )
                  ]),
                  child: const VerticalDivider(
                    indent: 5,
                    endIndent: 5,
                    color: Color.fromRGBO(23, 182, 20, 1),
                    thickness: 2,
                  ),
                ),
                const SizedBox(width: 15),
                SizedBox(
                  width: 225,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      event.awayTeam.teamName,
                      style: const TextStyle(
                          color: Color.fromRGBO(10, 17, 88, 1), fontSize: 30),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
