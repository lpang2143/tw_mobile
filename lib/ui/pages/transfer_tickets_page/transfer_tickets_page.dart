import 'package:flutter/material.dart';
import 'package:tw_mobile/data/classes/ticket.dart';
import 'package:tw_mobile/data/contacts.dart';
import 'package:tw_mobile/services/api_client.dart';
import 'package:tw_mobile/ui/pages/transfer_tickets_page/email_ticket.dart';
import 'package:tw_mobile/ui/shared/event_widget.dart';
import 'package:tw_mobile/data/classes/event.dart';

class TransferTicketsPage extends StatefulWidget {
  final Event event;
  final EventType eventType;
  final List<SeatObject> selectedSeats;
  final void Function(int index, List<SeatObject>) updateSeats;

  const TransferTicketsPage(
      {super.key,
      required this.event,
      required this.eventType,
      required this.selectedSeats,
      required this.updateSeats});

  @override
  State<TransferTicketsPage> createState() => _TransferTicketsPageState();
}

class _TransferTicketsPageState extends State<TransferTicketsPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 15),
            const TopRow(),
            SizedBox(
              height: height + 30, // Size of frame
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  const Positioned.fill(
                    top: 150,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(107, 149, 255, 1),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(70),
                            topRight: Radius.circular(70)),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Transform.scale(
                        scale: 1.15,
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: EventButton(
                            event: widget.event,
                            eventType: widget.eventType,
                            tappable: false,
                            selectedSeats: widget.selectedSeats,
                            updateSeats: widget.updateSeats,
                          ),
                        ),
                      ),
                      const Image(
                        width: 180,
                        image: AssetImage("lib/assets/AppleWallet.png"),
                      ),
                      const RecipientRow(),
                      ContactsButtonRow(
                        selectedSeats: widget.selectedSeats,
                      ),
                      const ChooseSeatsRow(),
                      Center(
                        child: Column(
                          children: [
                            ListView.builder(
                              // padding: const EdgeInsets.only(top: 30),
                              shrinkWrap: true,
                              itemCount: widget.selectedSeats.length,
                              itemBuilder: (context, index) {
                                final seating = widget.selectedSeats[index];
                                return Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Seat(
                                        seatNumber: seating.seatNumber,
                                        section: seating.section,
                                        row: seating.row,
                                        isSelected: seating.selected,
                                        onPressed: () {
                                          setState(
                                            () {
                                              widget.updateSeats(
                                                  index, widget.selectedSeats);
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 300,
                        child: Stack(
                          children: [
                            Center(
                              child: SendButton(widget: widget),
                            ),
                            Positioned(
                              right: 10,
                              child: IconButton(
                                  onPressed: () {
                                    debugPrint('Info Icon Pressed');
                                  },
                                  icon: Icon(Icons.info_outline,
                                      color: Color.fromRGBO(101, 72, 234, 1))),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SendButton extends StatefulWidget {
  const SendButton({super.key, required this.widget});

  final TransferTicketsPage widget;

  @override
  State<SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<SendButton> {
  @override
  Widget build(BuildContext context) {
    if (widget.widget.selectedSeats.any((seat) => seat.selected)) {
      return ElevatedButton(
        onPressed: () async {
          ApiClient apiClient = ApiClient();
          String json =
              seatsToJson(widget.widget.selectedSeats, recipientId: 31);
          await apiClient.transferTickets(json, 'nate@test.com');
          if (mounted) {
            Navigator.of(context).pop();
          }
        },
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(vertical: 10, horizontal: 70)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          )),
          backgroundColor: const MaterialStatePropertyAll(Color(0xFF656B98)),
        ),
        child: Text(
          'Send',
          style: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(fontSize: 20, color: Colors.white),
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: null,
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(vertical: 10, horizontal: 70)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          )),
          backgroundColor: const MaterialStatePropertyAll(Colors.red),
        ),
        child: Text(
          'Send',
          style: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(fontSize: 20, color: Colors.white),
        ),
      );
    }
  }
}

class Seat extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isSelected;
  final int seatNumber;
  final String row;
  final String section;

  const Seat({
    super.key,
    required this.seatNumber,
    this.row = '',
    this.section = '',
    required this.onPressed,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: Container(
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFF656B98) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0xff7CA1FE),
              blurRadius: 4,
            )
          ],
        ),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            onPressed: onPressed,
            child: Row(
              children: [
                const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                ),
                Align(
                  child: Text(
                    '$section · Row $row · Seat $seatNumber',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

class ChooseSeatsRow extends StatelessWidget {
  const ChooseSeatsRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Choose Seats",
            style: TextStyle(
              color: Color.fromRGBO(10, 17, 88, 1),
              fontSize: 20,
            ),
          ),
          TextButton(
            onPressed: () {
              debugPrint("Select All Pressed");
            },
            child: const Text(
              "Select All",
              style: TextStyle(
                color: Color(0xff625BF6),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ContactsButtonRow extends StatelessWidget {
  List<SeatObject> selectedSeats;
  ContactsButtonRow({
    super.key,
    required this.selectedSeats,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Expanded(
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor:
                            const Color.fromRGBO(101, 107, 152, 1)),
                    onPressed: () {
                      if (!selectedSeats.any((seat) => seat.selected)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.black,
                            content: Text('Please select seats first!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return EmailPopup(
                              selectedSeats: selectedSeats,
                            );
                          },
                        ).then((value) => Navigator.of(context).pop());
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.email_outlined,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Send to Email',
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  )
                ],
              ),
            ),
            Row(
              children: contacts
                  .map(
                    (data) => ContactsButton(name: data),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactsButton extends StatelessWidget {
  final String name;

  const ContactsButton({required this.name});

  @override
  Widget build(BuildContext context) {
    String initials = name[0] + name[name.indexOf(' ') + 1];
    String firstName = name.substring(0, name.indexOf(' '));
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: const Color.fromRGBO(101, 107, 152, 1)),
          onPressed: () {
            debugPrint("$name Pressed");
          },
          child: SizedBox(
              height: 68,
              width: 68,
              child: Center(
                  child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ))),
        ),
        const SizedBox(height: 10),
        Text(
          firstName,
          style: const TextStyle(color: Colors.black, fontSize: 12),
        )
      ],
    );
  }
}

class RecipientRow extends StatelessWidget {
  const RecipientRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Recipient",
            style: TextStyle(
              color: Color.fromRGBO(10, 17, 88, 1),
              fontSize: 20,
            ),
          ),
          TextButton(
            onPressed: () {
              debugPrint("Contact List Pressed");
            },
            child: const Text(
              "Contact List",
              style: TextStyle(
                color: Color.fromRGBO(134, 64, 249, 1),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TopRow extends StatelessWidget {
  const TopRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
                  Border.all(color: const Color.fromRGBO(107, 149, 255, 0.7))),
          child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Padding(
                padding: EdgeInsets.only(left: 7),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Color.fromRGBO(10, 17, 88, 1),
                ),
              )),
        ),
        const Text(
          'Transfer',
          style: TextStyle(
            color: Color.fromRGBO(10, 17, 88, 1),
            fontSize: 25,
          ),
        ),
        Container(
          constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
                  Border.all(color: const Color.fromRGBO(107, 149, 255, 0.7))),
          child: const Center(
            child: Text(
              'TG',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(10, 17, 88, 1),
                fontSize: 25,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
