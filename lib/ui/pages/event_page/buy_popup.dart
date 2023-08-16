import 'package:flutter/material.dart';
import 'package:tw_mobile/data/classes/ticket.dart';

class BuyTicketPopup extends StatefulWidget {
  final Ticket ticket;

  const BuyTicketPopup({required this.ticket});

  @override
  _BuyTicketPopupState createState() => _BuyTicketPopupState();
}

class _BuyTicketPopupState extends State<BuyTicketPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ticket Buy Placeholder'),
      content: Text(
          'Ticket ID: ${widget.ticket.ticketId}, Event ID: ${widget.ticket.eventId}'),
      actions: [
        TextButton(
          onPressed: () {
            //
            // ADD BUYING FUNCTIONALITY HERE WITH STRIPE
            // Probably by making a separate Stripe module and adding it here
            // instead of doing everything actually inside onTap
            //
            debugPrint(
                'BUY button pressed for ticket ID: ${widget.ticket.ticketId}');
          },
          child: Text('BUY'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Close'),
        ),
      ],
    );
  }
}
